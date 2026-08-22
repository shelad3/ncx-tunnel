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
