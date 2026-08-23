# NCX Tunnel v0.1.0-alpha

First public build of **NCX Tunnel** — an Android VPN client built on the
open-source [L×Box](https://github.com/Leadaxe/LxBox) core (sing-box /
libbox, GPL-3.0), rebranded and repackaged by
[shelad3](https://github.com/shelad3).

## Downloads

| File | Best for |
|---|---|
| `NCX.Tunnel-v0.1.0-alpha-arm64-v8a.apk` | Most phones since ~2016 (recommended) |
| `NCX.Tunnel-v0.1.0-alpha-armeabi-v7a.apk` | Older 32-bit phones |
| `NCX.Tunnel-v0.1.0-alpha-x86_64.apk` | Emulators / Chromebooks |
| `NCX.Tunnel-v0.1.0-alpha-universal.apk` | Any device (largest file) |

Install: download the APK, allow "install unknown apps" if prompted, open,
grant VPN permission, add your subscription URL or a `vless://` / link, connect.

## What is inside

- Full sing-box engine: VLESS, VMess, Trojan, Shadowsocks, WireGuard, Hysteria2,
  TUIC, Reality, SSH transports
- Subscriptions, per-app proxying, rule-based routing, DNS overrides
- Fresh NCX branding, package id `com.nativecodex.ncxtunnel`, update channel
  pointing at this repository

## Known limitations (alpha)

- APKs are **debug-signed** in this alpha (no release keystore yet)
- No auto-update yet; grab new builds from the releases page or the
  [download site](https://shelad3.github.io/ncx-download/)
- Early testing stage — report issues on the tracker

## Credits & license

- Upstream app: [L×Box](https://github.com/Leadaxe/LxBox) by Leadaxe (GPL-3.0)
- Engine: [sing-box](https://github.com/SagerNet/sing-box) / libbox
- This fork's changes are documented in
  [MODIFICATIONS.md](https://github.com/shelad3/ncx-tunnel/blob/develop/MODIFICATIONS.md)

SHA-256 (`universal`):
`4959427be6b49b36cecddec9f7d6958e6f10ac617eb08d2a9fc3e02f37cc62a6`
