# Agent guide (NCX Tunnel)

Rules for AI agents and automation working in this repository.

## Git: commits and pushing

- Work happens on **`ncx/develop`**. `main` mirrors upstream L×Box releases
  and must stay pristine for merges; do not commit feature work to `main`.
- Commit finished, verified work (analyze/tests green) as atomic commits with
  meaningful messages. Stage files explicitly — never `git add .`.
- Never rewrite published history; never push `--force`; tags are reserved for
  the release process.
- Upstream remote: `upstream` (https://github.com/Leadaxe/LxBox).
  Origin: https://github.com/shelad3/ncx-tunnel

## GPL compliance (hard rule)

This is a GPL-3.0 fork of L×Box linking GPL libbox. Every change must:

- preserve copyright notices and license headers;
- be documented in `MODIFICATIONS.md` when substantial;
- never introduce proprietary code, secrets, keystores or private credentials;
- keep attribution (About screen credits, NOTICE, THIRD_PARTY_LICENSES.md).

## UI language

User-facing product text is **English only** (screens, menus, buttons,
dialogs, snackbars, notifications, errors). Russian may exist only in the
inherited localization asset until proper i18n replaces it. Documentation,
code comments and commit messages may be any language the author prefers
(upstream heritage is Russian).

## Verification before commit

```bash
cd app && flutter analyze && flutter test
```

Device-dependent features additionally require an APK build and manual
confirmation.

## Release signing

- The upload keystore lives at `/mnt/link/ncx-tunnel/keys/upload-keystore.jks`
  (alias `ncx-upload`, 30-year validity). It is the update identity — **never
  delete, regenerate or commit it**; losing it permanently breaks updates for
  existing installs. Password is in `keys/.pass` next to it (chmod 700 dir).
- CI reads it from repo secrets: `ANDROID_KEYSTORE_BASE64`,
  `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_PASSWORD`, `ANDROID_KEY_ALIAS`
  (see `.github/workflows/ci.yml`). Without them builds fall back to debug
  signing — do not ship those as releases.
- Local signed builds use `app/android/key.properties` (gitignored) pointing
  `storeFile` at the keystore path above.
- Releases are cut by pushing a `v*` tag; if tag-push CI does not fire on this
  repo, run it manually:
  `gh workflow run ci.yml --ref <tag> -f run_mode=release`.
