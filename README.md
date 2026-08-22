# NCX Tunnel

**Connect simply. Configure freely. Know what you're running.**

NCX Tunnel is an open-source Android tunneling client built on Flutter and
[sing-box](https://github.com/SagerNet/sing-box) (via libbox), redesigned around a
first-class custom configuration ecosystem: discover, import, customize, test,
save and activate network configurations.

> NCX Tunnel is a fork of [L×Box](https://github.com/Leadaxe/LxBox) by Leadaxe
> (GPL-3.0). Substantial modifications are documented in
> [MODIFICATIONS.md](MODIFICATIONS.md). In accordance with GPL-3.0, this project
> is distributed under the same license.

## Status

Development / architecture phase. See [docs/](docs/) for inherited upstream
design documents (Russian) and [MODIFICATIONS.md](MODIFICATIONS.md) for the
change log of this fork.

## Roadmap

| Phase | Scope | Status |
|---|---|---|
| 0 | Fork L×Box, preserve license, clean build | ✅ |
| 1 | Rebrand (package ID, UI strings, icons, theme) | 🚧 |
| 2 | Flutter UI refactor — Home / Configs / Servers / Activity / Settings | ⏳ |
| 3 | Config catalogue (GitHub manifest → cards → connect) | ⏳ |
| 4 | Custom configuration import (paste / QR / file / URL / raw JSON) | ⏳ |
| 5 | Testing & diagnostics hardening | ⏳ |
| 6 | Monetization (ads, premium entitlement) | ⏳ |

## Build

```bash
cd app
flutter pub get
flutter run          # debug
flutter build apk    # release signing is NOT part of this repo
```

Requirements: Flutter 3.x (Dart ^3.11), Android SDK. The sing-box core is
consumed as a prebuilt `libbox` AAR — see `scripts/fetch-libbox.sh`.

## Repository layout

```
app/            Flutter application (lib/, android/, assets/, test/)
docs/           Design documents and specs
scripts/        Build / CI / diagnostics helpers
fastlane/       Store metadata
public-servers-manifest.json   Remote community server lists
```

## License

GPL-3.0 — see [LICENSE](LICENSE), [LICENSING.md](LICENSING.md),
[NOTICE](NOTICE) and [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md).

Because NCX Tunnel links against GPL-3.0 `libbox` (sing-box), every compiled
build (APK/AAB) is a combined GPLv3 work and must remain under GPLv3 when
redistributed. The public repository must never contain secrets, keystores or
private credentials.
