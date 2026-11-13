#!/usr/bin/env bash
# The whole suite, the same locally and in CI: every engine test project, the
# C# build, the import, the boot smoke and every tests/test_*.gd. Each step's
# log goes to .dev/ci/; a step fails on a nonzero exit, a timeout, or an
# error in its log (tools/ci/log_errors.sh). Ends SUITE PASS or SUITE FAIL.
#   tools/ci/run_tests.sh        (GODOT=<path> if godot is not Godot 4.7.2 .NET)
set -u
cd "$(git rev-parse --show-toplevel)"
GODOT="${GODOT:-godot}"
TIMEOUT_S="${TEST_TIMEOUT_S:-900}"
out=.dev/ci
mkdir -p "$out"
fails=0

step() {  # step <name> <command...>
  local name=$1; shift
  local log="$out/$name.log"
  if timeout "$TIMEOUT_S" "$@" > "$log" 2>&1; then
    echo "ok    $name"
  else
    echo "FAIL  $name (exit $?, $log)"; tail -n 20 "$log"; fails=$((fails + 1))
  fi
}

godot_step() {  # godot_step <name> <script.gd>
  local name=$1 script=$2
  step "$name" "$GODOT" --headless --path . --script "res://$script"
  if [ -f "$out/$name.log" ] && ! tools/ci/log_errors.sh "$out/$name.log" "$script" > "$out/$name.errors"; then
    echo "FAIL  $name (errors in its log)"; cat "$out/$name.errors"; fails=$((fails + 1))
  fi
}

for p in engine/*.Tests; do
  [ -d "$p" ] && step "engine-$(basename "$p")" dotnet run --project "$p" -c Release
done
step build dotnet build GameNs.csproj -nologo
step import "$GODOT" --headless --path . --import
godot_step boot src/dev/boot_smoke.gd
for t in tests/test_*.gd; do
  [ -f "$t" ] && godot_step "$(basename "$t" .gd)" "$t"
done

if [ "$fails" -eq 0 ]; then echo "SUITE PASS"; else echo "SUITE FAIL: $fails step(s)"; exit 1; fi
