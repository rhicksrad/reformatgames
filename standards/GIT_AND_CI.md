# Git and CI

Policy IDs: G1–G6 in [POLICIES.md](POLICIES.md).

## Branches and pull requests

- Never push to `main` (G1). Every change is a branch and a pull request.
- Agent branches are named for the work (`claude/<topic>`, `art/<lane>`,
  `server/<topic>`). Long-lived non-`main` lines are named for what they
  hold: `server/cloudflare` (backend), `deploy/<version>` (what was actually
  deployed), `site/landing` (a site kept beside the game). **[GB]**
- Open pull requests as drafts while iterating and mark them ready when they
  should run CI. **[SH]**
- PR bodies keep the repository's attribution lines and say what was
  verified and what was reused.
- Parallel work gets its own clone or worktree, deleted when the work ends.
- Parked work (unmerged branches worth keeping) is listed in `HANDOFF.md`
  with what each holds; everything else merged or superseded is deleted.

## Merging

- Merge only when every check-run on the current head concluded `success`
  (G2). A cancelled or skipped shard is not green. Never `--auto`, never a
  local pass instead of CI, never a stale head.
- Squash single pull requests. A stack merges bottom up with merge commits,
  retargeting each to `main` as the one below lands; never delete a branch
  another pull request is based on. **[SH]**
- Gate a queue as one batch when many pull requests are ready: integrate
  them locally, run one suite (and one perf set if any touches performance),
  then merge each green one in order. Bisect only if the batch is red. **[SH]**
- Docs-only pull requests have no CI run and merge on the pre-push hook (G3).
- Main has no CI on push; after a doubtful merge, dispatch the suite on `main`
  and fix forward if red. **[SH]**

## Pre-push hook

Each game ships `tools/hooks/pre-push` and every clone turns it on once:
`git config core.hooksPath tools/hooks`. It runs in seconds, with no Godot,
on what the push changes against `origin/main` (G4):

- `git diff --check` (whitespace errors, conflict markers);
- no CRLF in committed text files;
- `bash -n` on shell scripts, a parse of every Python and JSON file;
- a provenance record for every new generated image;
- `dotnet build` when a `.cs` or `.csproj` changed;
- the game's own cheap guards (test selectors, translation rules).

The template's hook is in
[templates/new-game/tools/hooks/pre-push](../templates/new-game/tools/hooks/pre-push).
`git push --no-verify` skips it for one push.

## CI

The reference is SHAHANSHAH's `Tests` workflow (`.github/workflows/tests.yml`
and `tools/ci/`):

- Runs on pull requests that are ready (not drafts) and touch more than docs
  (`paths-ignore: docs/**, **.md`), nightly on `main`, and by hand.
- One script is the whole suite (`tools/ci/run_tests.sh`), the same locally
  and in CI.
- Sharded across the online runners; a pull request whose changes reach only
  some tests runs only those plus the static audit.
- Repositories are private on a free plan, so hosted minutes are scarce. Jobs
  run on self-hosted runners on the owner's machines when the repo variable
  `CI_RUNNER` selects them, and fall back to `ubuntu-latest` when it is unset.
  Runners install Godot .NET and .NET user-local and run as user services; a
  gate takes a runner's label off while that machine is busy with perf work or
  low on memory.
- Export workflows (demo builds) run only by hand.

Galaxy Brain and Persian Strike have no Actions today: their CI is the
verification list in the rules file, run by whoever makes the change. New
games start with the template workflow
([templates/new-game/.github/workflows/tests.yml](../templates/new-game/.github/workflows/tests.yml)).
See [CONFLICTS.md](CONFLICTS.md) C7.

## Line endings

- Text is stored LF. Shell scripts are always checked out LF
  (`*.sh text eol=lf`), or the shebang breaks on Linux.
- Binary assets are marked `binary` in `.gitattributes`.
- Upstream sources kept byte for byte (their SHA-256 is recorded) are marked
  `-text` or `binary` so no checkout rewrites them.
- `.import` sidecars: SHAHANSHAH stores and checks them out LF like every other
  text file; Persian Strike and Galaxy Brain pin `*.import text eol=crlf`
  because Godot on Windows rewrites them CRLF. New games use LF everywhere;
  the reasons are in [CONFLICTS.md](CONFLICTS.md) C3. If a Windows clone lists
  every `.import` file as modified with an empty diff after an import,
  `git checkout -- '*.import'` clears it.

## What is never committed

`.godot/`, `build/`, `bin/`, `obj/`, `.dev/` output, logs, `*.tmp`,
`.claude/settings.local.json`, `override.cfg`, editor folders, OS clutter,
full-size art masters (they live in R2 or the machine's art archive), tokens,
signed URLs, and anything regenerated at release time (baked maps, shipped
caches). The template `.gitignore` covers these.
