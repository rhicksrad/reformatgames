#!/usr/bin/env bash
# Prints the errors in a Godot run's log that should fail it, and exits 1 if
# there are any: every SCRIPT ERROR and every engine ERROR, less the ones a
# headless run cannot help and the ones the test says it provokes.
#   tools/ci/log_errors.sh <log> [tests/test_x.gd]
# A GDScript error ends only the function it happens in, so a rule test whose
# sub-test dies part-way still counts its earlier checks, prints PASS and exits
# 0 with the rest never run. The exit code alone cannot see that; the log can.
# Left out:
# - the dummy renderer's races (about one headless boot in four, an engine
#   bug): a null-parameter or wrong-RID error raised from the dummy storage or
#   the RID owner, and the dummy RIDs it then leaks;
# - what Godot reports as still held while it quits (resources in use, leaked
#   RIDs), which comes after the test's verdict. STRICT_EXIT=1 keeps those in
#   (the main scene's boot must quit clean);
# - any error whose text holds a string the test declares it provokes, one per
#   line in the test file: `## expect-error: <text>`.
set -u
log="${1:?usage: tools/ci/log_errors.sh <log> [test.gd]}"
test_file="${2:-}"
expected="$(mktemp)"
trap 'rm -f "$expected"' EXIT
if [ -n "$test_file" ] && [ -f "$test_file" ]; then
  sed -n 's/^## expect-error: *//p' "$test_file" | sed 's/[[:space:]]*$//' | grep -v '^$' > "$expected" || true
fi
found=$(
  awk -v strict="${STRICT_EXIT:-0}" '
    function race(m) {
      return m ~ /^ERROR: (Parameter "(t|m|mem)" is null\.|Attempting to initialize the wrong RID|Initializing already initialized RID)$/
    }
    function at_exit(m) {
      return strict != 1 && m ~ /^ERROR: [0-9]+ (resources still in use at exit|RID allocations of type .* were leaked at exit)/
    }
    # An ERROR with no "at:" line after it (repeated near exit) is dropped
    # only when it is exactly one of the race messages.
    function flush() { if (msg != "" && !race(msg)) print msg; msg = "" }
    { sub(/\r$/, "") }
    /^ERROR: [0-9]+ RID allocations of type .*Dummy/ { flush(); next }
    /^ERROR: / { flush(); if (!at_exit($0)) msg = $0; next }
    /^   at: / && msg != "" {
      if ((index($0, "servers/rendering/dummy/") || index($0, "core/templates/rid_owner.h")) && race(msg)) { msg = ""; next }
      print msg; msg = ""; next
    }
    { flush() }
    /^SCRIPT ERROR/ { print }
    END { flush() }
  ' "$log" | { if [ -s "$expected" ]; then grep -vF -f "$expected"; else cat; fi; }
)
[ -z "$found" ] && exit 0
printf '%s\n' "$found" | sort | uniq -c | sort -rn | sed 's/^ *\([0-9]*\) /\1x /'
exit 1
