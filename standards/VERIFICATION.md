# Verification

How a change is proven before it merges. Policy IDs: V1–V6 in
[POLICIES.md](POLICIES.md).

## Tiers

| Tier | When | What | Example |
| --- | --- | --- | --- |
| **T0** static | Every change | Seconds, no GPU: static audit script, syntax, data validation, provenance checks | SHAHANSHAH `tests/test_static_audit.gd`; Persian Strike `scripts/audit_*.py` |
| **T1** focused | What changed | The rule test or smoke for that area, headless | `tests/test_<area>_rules.gd`; `dotnet run --project engine/<X>.Tests` |
| **T2** full | Before every merge | The whole suite, as CI runs it: every engine test project, the C# build, the import, a boot of the main scene, every rule test, the headless perf smoke | SHAHANSHAH `tools/ci/run_tests.sh` |
| **T3** rendered | Any visual or performance change | Real-renderer captures inspected at full size; the perf tour before and after | `tests/review_tour.gd`, `tests/perf_tour.gd`; Galaxy Brain `src/dev/*_capture.gd` |

A docs-only change needs a diff read, a link check and a consistency check
against the rules file, not a Godot run.

## Runner contract

Every runner, smoke, tour and audit (V2):

- ends with an exact `PASS` or `FAIL` line (`PERF TOUR PASS`, `SMOKE PASS`);
- exits nonzero on failure, with documented exit codes when it has more than
  one failure mode (Persian Strike: 64 bad invocation, 65 parse/compile
  abort, 66 timeout);
- has a hard timeout and ends a hung Godot with its stacks;
- writes its full log to a file. The report gives the exit status, the
  required markers and the failures, and the log path;
- fails on any `SCRIPT ERROR` or engine `ERROR` in its log even if it exited 0,
  because a GDScript error ends only the function it happens in and a test can
  print PASS with half its checks unrun. A test that provokes an error on
  purpose declares it in its header (`## expect-error: <text>`). **[SH]**
  (`tools/ci/log_errors.sh` is the reference checker.)

## Running Godot

- One Godot per machine (W9). Run one-off Godot through the game's wrapper,
  which queues behind other runs and ends hung ones (SHAHANSHAH
  `tools/ci/gpu_shared.sh`, Persian Strike `.dev/run_godot.sh`).
- On a fresh clone or after merging `main`: `dotnet build <Game>.csproj`, then
  `godot --headless --path . --import` (twice in a fresh cloud container).
- Rendered runs in a container go under `xvfb-run`.
- Never run a check over the owner's game session or in the owner's own
  checkout; use a scratch clone or worktree.

## Godot import hygiene

After every Godot GUI, editor, import, runner or game invocation (V4):

```bash
git status --short --untracked-files=all -- '*.import'
git diff --name-only -- '*.import'
git diff --cached --name-only -- '*.import'
```

All three are empty before handoff, unless the task intentionally changed an
import and the change was inspected. A clean normalized diff is not proof:
Git can still list thousands of stat or line-ending modifications. Never reset
real importer-setting changes to make the audit look clean. How each repo
avoids `.import` line-ending churn is in
[GIT_AND_CI.md](GIT_AND_CI.md#line-endings).

## Visual truth

For every visual change (V3):

- Inspect full-resolution renders produced after the last change, at the
  gameplay camera and close up. A capture set for a new or redesigned asset:
  hero, front, rear, roof, grazing angle, gameplay distance, plus night and
  weather if the game has them. **[SH] [PS]**
- Never present clipping, floating or detached parts, z-fighting, stretched
  textures, unreadable identity, clipped UI text, overlaps, or stray lettering
  in generated art.
- A defect found by eye gets an objective runner assertion where practical,
  so it cannot come back (V5).
- Link only captures produced and inspected after the final change.

## Static audits

When a defect class recurs, write an audit (Python or a headless GDScript)
with a zero-violation pass and add it to T0 or CI (V5). Examples:
SHAHANSHAH's UI art rules and art-nesting rules, Persian Strike's
render-depth and vehicle-lighting audits, Galaxy Brain's art-path check.

## Reporting

Report each kind of evidence separately (V6): static checks, focused runtime
tests, visual inspection, active play, owner approval, export, publication,
remote SHA match. Evidence for one never establishes another. Placement,
composition and feel remain the owner's judgment; do not replace them with
brittle assertions.
