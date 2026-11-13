# Starting a new game

The checklist that takes a new Reformat Games title from nothing to a
repository an agent can work in on day one. It copies
[templates/new-game/](../templates/new-game/) and applies the standards.
Each step names the policy it satisfies.

## 1. Decide

- [ ] **Working title and slug** (`galaxy-brain`, `shahanshah`): repo name,
  itch slug, domain. Search Steam, itch, BoardGameGeek and USPTO for the name
  before anything public.
- [ ] **Namespace** for game code (`GalaxyBrain`, `Shahanshah`).
- [ ] **Pitch, core loop, tone, platforms, monetization** in a first
  `docs/GDD.md`. Monetization and region limits go in the rules file as hard
  rules.
- [ ] **IP guardrails:** the franchises and terms this game must never use
  (B7).
- [ ] **Which Qanat modules it needs** ([ENGINE.md](ENGINE.md)). If a module
  will be shared for the first time, settle [CONFLICTS.md](CONFLICTS.md) D2.
- [ ] **Release authority:** does this game ship on the ask, or on an explicit
  ask per build (W3, C1)?

## 2. Create the repository

- [ ] Create a **private** repository `rhicksrad/<Name>` with a `main` branch.
- [ ] From a clone of this repository, run:

  ```bash
  tools/new_game.sh <target-dir> "<Display Name>" <Namespace> <slug>
  ```

  It copies `templates/new-game/` and replaces `GAME_NAME`, `GameNs` and
  `game-slug` in file contents and names. Read the result, then commit it as
  the first commit.
- [ ] `git config core.hooksPath tools/hooks` (G4).
- [ ] Protect `main` from direct pushes if the plan allows it (G1).

## 3. Make it build

- [ ] Install Godot 4.7.2 .NET and the .NET 10 SDK.
- [ ] Open the folder in the Godot .NET editor once so it writes
  `project.godot`'s UID cache; keep the template's settings.
- [ ] `dotnet build <Namespace>.csproj`, then
  `dotnet run --project engine/<Namespace>.Engine.Tests -c Release` prints
  `PASS` lines and exits 0 (Q6).
- [ ] `godot --headless --path . --import`, then the boot smoke:
  `godot --headless --path . --script res://src/dev/boot_smoke.gd` ends
  `SMOKE PASS` (V2).
- [ ] Commit the `.uid` files Godot generates beside scripts on the first
  import, then run the import audit (V4).

## 4. Wire the engine

- [ ] Put the first rule in `engine/<Namespace>.Engine`: a command, its
  validation, the events it emits, a snapshot. Add its test case (Q2, Q6).
- [ ] `src/engine/<Namespace>Host.cs` loads data, submits commands, drains
  events as signals, and returns snapshots as dictionaries. It holds no rules.
- [ ] Balance numbers go in the engine's config record from the first number
  (E4).
- [ ] Translation table set up before the first player-facing string (E12).

## 5. Fill in the docs

- [ ] `AGENTS.md`: what the game is, standing rules, hard rules, gates,
  verification commands, documentation map (R1). Delete template lines that
  do not apply.
- [ ] `docs/HANDOFF.md`: what is live (nothing yet), open work, branches, the
  machines this game runs on and what each is for (R2). Machine details stay
  here, never in the public standards.
- [ ] `docs/GDD.md`, `docs/ENGINE.md`, `docs/PERFORMANCE.md` (the reference
  machine and gates), `docs/IMAGE_GEN.md` and the first art brief.
- [ ] `docs/ASSET_MANIFEST.md`, `CREDITS.txt`,
  `docs/release/CHANGELOG.md` start empty but present (R6).

## 6. CI

- [ ] The template's `.github/workflows/tests.yml` runs
  `tools/ci/run_tests.sh` on ready pull requests. Set the repo variable
  `CI_RUNNER` to use the self-hosted runners, or leave it unset for hosted
  runners (G1, G2). Register a runner on a machine with `tools/ci` from
  SHAHANSHAH if self-hosted.
- [ ] Open a first pull request and see the workflow pass.

## 7. Brand

- [ ] Copy the Reformat Games ident and the "Powered by Qanat" card (and its
  shader) from SHAHANSHAH into `assets/ui/branding/`; wire the boot sequence
  (S4).
- [ ] App icon, title-screen studio line and version, credits screen
  generated from the credits data (S1, B1).
- [ ] `export_presets.cfg`: Windows and Linux presets with the studio
  metadata and the standard exclude filter (S1, E13). Do not export until a
  build is asked for.

## 8. Public presence (when the owner says it is time)

- [ ] itch page under the studio account, with the privacy note, CC-BY
  credits and AI disclosure.
- [ ] The game's site from the persianstrike.com generator
  ([WEBSITES.md](WEBSITES.md#a-new-games-site)).
- [ ] Add the game to reformatgames.com: games list, `sameAs`, sitemap.
- [ ] No promo before the dev work it shows is done (B4).
