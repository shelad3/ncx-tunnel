#!/usr/bin/env bash
# NCX fork helper: adapt pub-hosted plugins so everything builds with a
# single locally-installed NDK on metered/offline machines.
#
# 1) Pin every plugin's ndkVersion to the repo's NDK (plugins like
#    flutter_zxing pin their own version, making AGP auto-download another
#    ~700 MB NDK).
# 2) Patch flutter_zxing's vendored ZXing core: libc++ >= 18 (NDK r28)
#    removed the implicit std::char_traits<unsigned char> specialization
#    that its basic_string_view<char8_t> requires.
#
# Idempotent. Run after every `flutter pub get` / `pub upgrade` that changes
# plugin versions.

set -euo pipefail

NDK_VERSION="${1:-28.2.13676358}"
PUB_CACHE_DIR="${PUB_CACHE:-$HOME/.pub-cache/hosted/pub.dev}"

# --- 1) ndkVersion pins -----------------------------------------------------
patched=0
for f in "$PUB_CACHE_DIR"/*/android/build.gradle; do
  [ -f "$f" ] || continue
  if grep -q '^\s*ndkVersion "' "$f"; then
    sed -i -E "s|(^\s*ndkVersion\s+)\"[^\"]+\"|\1\"$NDK_VERSION\"|" "$f"
    patched=$((patched + 1))
    echo "  ndk pinned: ${f#$PUB_CACHE_DIR/}"
  fi
done

# --- 2) flutter_zxing char_traits shim --------------------------------------
shimmed=0
for f in "$PUB_CACHE_DIR"/flutter_zxing-*/src/zxing/core/src/Utf.cpp; do
  [ -f "$f" ] || continue
  if ! grep -q "NCX fork patch" "$f"; then
    python3 - "$f" <<'PYEOF'
import sys
p = sys.argv[1]
src = open(p).read()
anchor = "#include <sstream>"
shim = '''// NCX fork patch (scripts/patch-pub-plugins.sh): libc++ >= 18 (NDK r28)
// removed the implicit std::char_traits specialization for unsigned char,
// which the basic_string_view<char8_t> below requires.
#include <cstddef>
namespace std {
template <>
struct char_traits<unsigned char> {
  using char_type = unsigned char;
  using int_type = int;
  using off_type = streamoff;
  using pos_type = streampos;
  using state_type = mbstate_t;
  static constexpr void assign(char_type& r, const char_type& c) noexcept { r = c; }
  static constexpr bool eq(char_type a, char_type b) noexcept { return a == b; }
  static constexpr bool lt(char_type a, char_type b) noexcept { return a < b; }
  static constexpr int compare(const char_type* s1, const char_type* s2, size_t n) noexcept {
    for (; n; --n, ++s1, ++s2) {
      if (lt(*s1, *s2)) return -1;
      if (lt(*s2, *s1)) return 1;
    }
    return 0;
  }
  static constexpr size_t length(const char_type* s) noexcept {
    size_t n = 0;
    while (!eq(s[n], char_type(0))) ++n;
    return n;
  }
  static constexpr const char_type* find(const char_type* s, size_t n, const char_type& a) noexcept {
    for (; n; --n) {
      if (eq(*s, a)) return s;
      ++s;
    }
    return nullptr;
  }
  static constexpr char_type to_char_type(int_type c) noexcept { return char_type(c); }
  static constexpr int_type to_int_type(char_type c) noexcept { return int_type(c); }
  static constexpr bool eq_int_type(int_type a, int_type b) noexcept { return a == b; }
  static constexpr int_type eof() noexcept { return -1; }
};
} // namespace std'''
assert anchor in src, "Utf.cpp anchor not found"
open(p, "w").write(src.replace(anchor, anchor + "\n\n" + shim, 1))
print("  shim applied:", p)
PYEOF
    shimmed=$((shimmed + 1))
  fi
done

echo "✅ patch-pub-plugins: $patched ndk pin(s), $shimmed shim(s)"
