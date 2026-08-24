import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ncx_tunnel/services/community_servers_loader.dart';

http.Client _client(Object? body, {int status = 200}) =>
    MockClient((request) async => http.Response(
          body is String ? body : jsonEncode(body),
          status,
          headers: {'content-type': 'application/json'},
        ));

void main() {
  tearDown(() {
    // Сброс module-level кэша между тестами (loader кэширует первый успех).
    CommunityServersLoader.resetForTest();
  });

  test('манифест с именами и описаниями парсится полностью', () async {
    final m = await CommunityServersLoader.load(
      client: _client({
        'version': 1,
        'attribution': {
          'text': 'NCX curated',
          'link': 'https://github.com/shelad3/NCX-Configs',
        },
        'lists': [
          {
            'name': 'Free public nodes',
            'description': 'Community-contributed, untested',
            'source': 'https://example.com/free.txt',
          },
        ],
      }),
    );
    expect(m.attribution?.text, 'NCX curated');
    expect(m.lists.single.name, 'Free public nodes');
    expect(m.lists.single.description, 'Community-contributed, untested');
    expect(m.lists.single.source, 'https://example.com/free.txt');
  });

  test('легаси-запись без name/description → null (UI падает назад к List N)',
      () async {
    final m = await CommunityServersLoader.load(
      client: _client({
        'lists': [
          {'source': 'https://example.com/x.txt'},
        ],
      }),
    );
    expect(m.lists.single.name, isNull);
    expect(m.lists.single.description, isNull);
    expect(m.attribution, isNull);
  });

  test('пустые строки name/description трактуются как отсутствие', () async {
    final m = await CommunityServersLoader.load(
      client: _client({
        'lists': [
          {
            'name': '   ',
            'description': '',
            'source': 'https://example.com/y.txt',
          },
        ],
      }),
    );
    expect(m.lists.single.name, isNull);
    expect(m.lists.single.description, isNull);
  });

  test('записи без source выбрасываются', () async {
    final m = await CommunityServersLoader.load(
      client: _client({
        'lists': [
          {'name': 'no source'},
          {'source': '  '},
          {'source': 'https://example.com/ok.txt'},
        ],
      }),
    );
    expect(m.lists.length, 1);
    expect(m.lists.single.source, 'https://example.com/ok.txt');
  });

  test('HTTP != 200 → исключение (kill-switch через удаление файла)', () async {
    await expectLater(
      CommunityServersLoader.load(client: _client('gone', status: 404)),
      throwsException,
    );
  });

  test('битый JSON → исключение, не мусорный манифест', () async {
    await expectLater(
      CommunityServersLoader.load(client: _client('{not json')),
      throwsFormatException,
    );
  });

  test('успешный манифест кэшируется: второй вызов не бьёт по сети', () async {
    var hits = 0;
    final client = MockClient((request) async {
      hits++;
      return http.Response(
        jsonEncode({
          'lists': [
            {'name': 'cached', 'source': 'https://example.com/c.txt'},
          ],
        }),
        200,
      );
    });
    final a = await CommunityServersLoader.load(client: client);
    final b = await CommunityServersLoader.load(client: client);
    expect(hits, 1, reason: 'второй вызов должен прийти из кэша');
    expect(identical(a, b), isTrue);
  });

  test('инжектированный клиент не закрывается владельцем', () async {
    var closed = false;
    final client = MockClient((request) async => http.Response(
          jsonEncode({'lists': []}),
          200,
        ));
    // MockClient не экспортирует close-флаг; проверяем через closeCalls-обёртку.
    final wrapped = CloseTrackingClient(client, onClose: () => closed = true);
    await CommunityServersLoader.load(client: wrapped);
    expect(closed, isFalse, reason: 'чужой клиент — владелец его закрывает');
  });
}

class CloseTrackingClient extends http.BaseClient {
  CloseTrackingClient(this._inner, {required this.onClose});
  final http.Client _inner;
  final void Function() onClose;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      _inner.send(request);

  @override
  void close() {
    onClose();
    super.close();
  }
}
