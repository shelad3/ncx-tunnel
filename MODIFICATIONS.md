# Modifications relative to upstream L×Box

This file documents the substantial changes made in the NCX Tunnel fork,
as required by GPL-3.0 §5(a). Upstream: https://github.com/Leadaxe/LxBox
(fork point: v2.20.12, commit 590fd886).

## Phase 1 — Rebrand (this change set)

- Renamed Dart package `lxbox` → `ncx_tunnel`; rewrote all `package:lxbox/*`
  imports across `lib/`, `test/`, `tool/`.
- Android `namespace` / `applicationId`: `com.leadaxe.lxbox` →
  `com.nativecodex.ncxtunnel`.
- Moved Kotlin sources `com.leadaxe.lxbox.*` → `com.nativecodex.ncxtunnel.*`;
  renamed `LxBoxTileService` → `NcxTileService`,
  `LxBoxIntentReceiver` → `NcxIntentReceiver`, `LxBoxApp` → `NcxApp`.
- Renamed automation intent actions `com.leadaxe.lxbox.*` →
  `com.nativecodex.ncxtunnel.*` (manifest + Kotlin receivers + settings UI).
- Renamed platform channel namespaces `lxbox/*` → `ncx/*`
  (Dart `PlatformChannels` + Kotlin registration).
- User-Agent brand token `LxBox-android/<ver>` → `NCX-android/<ver>`.
- Storage/debug artifacts renamed: `lxbox_settings.json` → `ncx_settings.json`,
  `CrashReport-lxbox.log` → `CrashReport-ncx.log` (incl. libbox
  `crashReportSource = "ncx"`), backup/rules/dump file markers `"app": "lxbox"`
  → `"app": "ncx"`, deep-link scheme `lxbox://` → `ncx://`.
- Replaced all user-facing "L×Box" strings with "NCX Tunnel"
  (Dart UI, Android strings.xml en/ru, web manifest, quick-settings tiles).
- Update checker, project links, community-servers manifest, support and
  donate endpoints repointed from Leadaxe/LxBox to shelad3/ncx-tunnel.
- Removed upstream donation content (bundled wallet addresses belong to the
  upstream author); bundled `assets/donate.json` now ships an empty list.
- Replaced launcher icon with an NCX placeholder.
- Added this file, NOTICE, THIRD_PARTY_LICENSES.md; rewrote README.md and
  LICENSING.md for the fork while preserving upstream attribution.

Not yet changed (planned): app theme/colors, splash, final icon design,
UI information architecture (Phase 2+).
