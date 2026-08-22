import 'package:flutter_test/flutter_test.dart';
import 'package:ncx_tunnel/services/support/support_nav.dart';

/// §357 — парсер `ncx://action:payload` и резолвабельность действий.
void main() {
  group('SupportLinkAction.parse', () {
    test('route: экран и экран/вкладка', () {
      final a = SupportLinkAction.parse('ncx://route:dns')!;
      expect(a.action, 'route');
      expect(a.payload, 'dns');
      expect(routeSegments(a), ['dns']);

      final b = SupportLinkAction.parse('ncx://route:debug/profiling')!;
      expect(routeSegments(b), ['debug', 'profiling']);
    });

    test('payload — целый URI со своим ://, query и фрагментом', () {
      const uri =
          'vless://uuid@154.83.246.52:443?flow=xtls-rprx-vision&sni=x#%F0%9F%87%B3%F0%9F%87%B1';
      final a = SupportLinkAction.parse('ncx://add:$uri')!;
      expect(a.action, 'add');
      expect(a.payload, uri, reason: 'всё после первого ":" — сырой payload');
    });

    test('не-ncx и битые → null', () {
      expect(SupportLinkAction.parse('https://github.com/x'), isNull);
      expect(SupportLinkAction.parse('ncx://route'), isNull,
          reason: 'нет разделителя действия');
      expect(SupportLinkAction.parse('ncx://route:'), isNull,
          reason: 'пустой payload');
      expect(SupportLinkAction.parse('ncx://:dns'), isNull,
          reason: 'пустое действие');
      expect(SupportLinkAction.parse(''), isNull);
    });
  });

  group('isResolvableSupportAction', () {
    test('route: все экраны реестра резолвятся', () {
      for (final s in kSupportRouteScreens) {
        expect(
            isResolvableSupportAction(SupportLinkAction.parse('ncx://route:$s')!),
            true,
            reason: s);
      }
    });

    test('route: неизвестный экран / add: пустой / чужое действие → false', () {
      expect(
          isResolvableSupportAction(
              SupportLinkAction.parse('ncx://route:teleport')!),
          false);
      expect(
          isResolvableSupportAction(SupportLinkAction.parse('ncx://add: ')!),
          false);
      expect(
          isResolvableSupportAction(
              SupportLinkAction.parse('ncx://teleport:mars')!),
          false,
          reason: 'forward-compat: будущие действия старые версии прячут');
    });

    test('share: непустой payload резолвится и НЕ уводит с экрана', () {
      final a = SupportLinkAction.parse('ncx://share:Смотри — NCX Tunnel https://x')!;
      expect(a.action, 'share');
      expect(isResolvableSupportAction(a), true);
      expect(isInPlaceSupportAction(a), true);
      expect(
          isResolvableSupportAction(SupportLinkAction.parse('ncx://share:   ')!),
          false);
      // route/add — уводят (pushReplacement), не in-place.
      expect(
          isInPlaceSupportAction(SupportLinkAction.parse('ncx://route:dns')!),
          false);
    });

    test('route:about/donate — донат вкладкой, отдельного слага нет', () {
      final a = SupportLinkAction.parse('ncx://route:about/donate')!;
      expect(routeSegments(a), ['about', 'donate']);
      expect(isResolvableSupportAction(a), true);
      expect(
          isResolvableSupportAction(SupportLinkAction.parse('ncx://route:donate')!),
          false,
          reason: 'донат — состояние About, а не самостоятельный экран');
    });

    test('route: вкладка не влияет на резолвабельность', () {
      expect(
          isResolvableSupportAction(
              SupportLinkAction.parse('ncx://route:debug/whatever')!),
          true,
          reason: 'неизвестная вкладка деградирует к дефолтной на экране');
    });
  });
}
