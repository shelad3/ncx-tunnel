# Third-party licenses

NCX Tunnel depends on and derives from the following projects. This file is a
summary; full license texts are distributed alongside the source or included
in release artifacts.

| Project | Use | License | Source |
|---|---|---|---|
| L×Box | Fork foundation (all Dart/Kotlin app code unless noted) | GPL-3.0 | https://github.com/Leadaxe/LxBox |
| sing-box / libbox | VPN core, consumed as prebuilt AAR | GPL-3.0-or-later | https://github.com/SagerNet/sing-box |
| sing-box-lx | Upstream core fork used by L×Box (AmneziaWG 2.0, XHTTP) | GPL-3.0 | https://github.com/Leadaxe/sing-box-lx |
| singbox-launcher | Config wizard / parser reference (upstream credit) | see upstream | https://github.com/Leadaxe/singbox-launcher |
| Flutter | UI framework | BSD-3-Clause | https://github.com/flutter/flutter |
| Cloudflare logo (`assets/icons/cloudflare.png`) | WARP feature branding | CC0 (via Simple Icons) | https://simpleicons.org |

## Pub dependencies (app/pubspec.yaml)

All Dart packages are used under their OSI-approved licenses (BSD, MIT,
Apache-2.0). The authoritative list with versions is `app/pubspec.lock`;
per-package license texts can be generated with:

```bash
cd app && flutter pub deps && dart pub global activate license_checker
```

Release builds should regenerate and bundle the complete license notice set
(e.g. via `flutter pub run flutter_oss_licenses`) before public distribution.
