# Releases, branding and public text

How a Reformat Games build is versioned, exported, branded and shipped, and
the rules for anything the public reads. Policy IDs: S1–S6 and B1–B7 in
[POLICIES.md](POLICIES.md). Approval for exports, uploads and deploys is set
by W3 ([WORKING_WITH_AGENTS.md](WORKING_WITH_AGENTS.md#approvals)).

## Storefronts

- **itch.io** under the studio account: `reformatgames.itch.io/<game-slug>`.
  Builds go up with **butler** (`butler push <dir>
  reformatgames/<slug>:<channel> --userversion <version>`), credentials on the
  machine that pushes, never in a repository. Confirm with `butler status`.
- **Channels:** `windows`, `linux` for the game; `windows-demo`,
  `linux-demo` for a free demo. The same version on both platforms of a
  channel.
- **Steam** once a game has an app ID: Steamworks.NET built per OS, SteamPipe
  scripts under `tools/steam/`, separate Steam presets. SHAHANSHAH's
  `docs/STEAM.md` and `docs/STEAM_LAUNCH.md` are the reference.
- itch has no devlog API; devlogs are posted from a browser signed in to the
  studio account, images under 3 MB.

## Versions

- `config/version` in `project.godot` is the one version number; the title
  screen shows it in a corner and the exe metadata reads it.
- New games use **semantic versions** (`0.1.0`, `0.1.1`, …), with a pre-release
  suffix when a game runs several channels (`0.5.0-ea.N`, `0.5.0-demo.N`).
  Tag what shipped (`v0.1.3`, or `ea-v0.N` / `demo-v0.N`). See
  [CONFLICTS.md](CONFLICTS.md) C8 for the date-stamped Persian Strike scheme.
- One release owns each version number (S3). Check the store and the
  changelog for the next number before trusting anyone else's.

## Changelog

- `docs/release/CHANGELOG.md`: append-only, newest first, **player-facing
  only**, a `## <version>: <title>` heading per release. What a player will
  notice, in plain words; not how it was built.
- A game with an in-game "What's New" keeps it and the changelog in step, and
  the release script checks the top entry matches the version.

## Export presets

- `export_presets.cfg` is committed and holds no secrets (S1).
- Every Windows preset sets `application/company_name="Reformat Games LLC"`,
  `application/copyright="(c) <year> Reformat Games LLC"`, the product name,
  and file and product versions from `config/version`. The app icon is
  embedded.
- Every preset excludes dev and test code and tooling: `src/dev/*`, `tests/*`,
  `tools/*`, `engine/*` (source), `docs/*`, `.dev/*`, `build/*`, `.github/*`,
  `*.md`, prototypes and dev-only scenes (E13). The release script fails a
  pack that contains any of them.
- Demo presets carry a `demo` feature tag read through one static flag in
  code; content a demo player can never reach is left out of its pack.
- Builds ship unsigned unless a signing setup exists; the store page says so.
- Linux builds embed their pack; Windows builds ship the `.pck` beside the exe
  when an embedded pack would pass 4 GiB.

## Cutting a build

The reference is SHAHANSHAH's `tools/release/build_ea.sh` and its
`docs/RELEASE_PLAN.md`; Galaxy Brain's `tools/export_windows.py`; Persian
Strike's guarded `.dev/push_itch.sh --publish [--export]`. Whatever the
script, a cut:

1. starts from a clean, current `main`, in its own clone or worktree (S2), on
   the machine that holds the store login;
2. checks the version, the changelog/What's New entry, the credits and exe
   metadata, and that no excluded folder is in the pack;
3. exports every preset for the release, then runs a first-launch smoke test
   on each (`--headless -- --smoke-test`, the log must end with the smoke's
   PASS line; Windows under Wine with a scratch prefix);
4. prints a PASS/FAIL line per check and never uploads by itself;
5. uploads with butler only when the upload is authorized, then tags;
6. deletes the clone's `build/` afterwards.

Never auto-launch a newly exported game for the owner (S6). Publishing tools
are inert without an explicit flag (`--publish`), and a new export needs its
own (`--export`). **[PS]**

## Demos

The demo's scope is one list in code (SHAHANSHAH: `Scenario.DEMO`), checked by
a rule test and the exported smoke test (S5). The demo ends on a card that
says what the full game adds and links to it. Demo saves load in the full
game.

## Branding in builds

- **Boot sequence (S4):** a plain near-black engine splash, the Reformat
  Games ident (about 3 s), then the "Powered by Qanat" card (about 2 s) for
  games on Qanat, then the title. Enter, Space, a click or Start skips a card;
  Escape skips all. Warm shaders and glyphs while the cards play.
- **Title screen:** a small "A Reformat Games game" line and the version.
- **Credits** open with Reformat Games, then the licensed-asset list
  generated from the game's credits data. A test or the release script fails a
  build whose credits name a person.
- **Qanat marks:** the wordmark, monogram and splash card live in
  SHAHANSHAH's `docs/brand/` with their SVG sources, colours (Lapis `#1F3A5F`,
  Night `#14171C`, Sand `#E8D3AE`, Sandstone `#D9B98A`, Turquoise `#2BA6A0`)
  and the card's water shader. A game copies the splash it uses into its own
  assets. Write "Qanat" in prose, "QANAT" only in the wordmark; "Powered by
  Qanat" or "Built with Qanat, the Reformat Games engine" (B3).

## Public text and legal names

- **No personal names, emails or addresses** in anything public (B1): store
  pages, devlogs, credits, in-game text, site copy, press kits, video
  descriptions, commit messages that ship. Public text is signed "Reformat
  Games".
- **"Reformat Games"** is the brand on screen. **"Reformat Games LLC"** goes
  only where a legal entity is named (B2): copyright lines (`© <year>
  Reformat Games LLC`), exe metadata, terms and privacy pages, press-kit fact
  sheets, site footers.
- **Disclosures:** every store page carries the CC-BY credits, the game's
  privacy note (the same words as the in-game privacy page; change both
  together), and an AI disclosure for generated art and sound.
- **Privacy:** a game sends nothing about the player unless the feature needs
  it, and the privacy note says exactly what goes online and how to turn it
  off. **[SH]**
- **Third-party IP (B7):** each game's rules file lists the franchises and
  terms it must never use. Parody is original characters and names, never a
  lookalike.
- **Fiction disclaimers (B6)** stay visible on general-audience promotion for
  games set in real-feeling places.
- **Monetization** is set per game in its rules file and design doc
  (Galaxy Brain: only the Admin Council seat is sold; nothing that buys cards,
  power or progress). No game adds a store, paid currency or pass without the
  owner's decision.

## Promotion

- No promo before dev (B4).
- Marketing images are real current-build captures, at full resolution, with
  no text overlays; captions live beside the image (B5). Verify a capture
  against the current build before replacing a stronger public image.
- Marketing shots and trailers render only on a machine with a discrete GPU.
- Site videos: H.264, yuv420p, fast-start, AAC audio kept.
- Trailers go to the Reformat Games YouTube channel; on that channel an agent
  does only the step the owner hands over, in the owner's browser tab.
- A devlog is posted only once a live build carries everything it describes;
  the owner sees every draft first. It shows what a player sees, grouped by
  feature, with three to five captioned in-game captures. Each devlog gets a
  one-line news item on reformatgames.com ([WEBSITES.md](WEBSITES.md)).
