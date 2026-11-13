# Where the repositories disagree

The survey behind these standards found places where the games do things
differently. For each, this page says what each repo does, what the studio
standard picked and why, and whether existing games should change. Items
marked **Decision** need the owner's call; until then the standard's pick
applies to new games only and existing games keep their own rule.

Repos: **PS** Persian Strike (`Choppa2`), **SH** SHAHANSHAH (`Pharaoh`),
**GB** Galaxy Brain.

## Conflicts with a picked standard

### C1. Release approval (**Decision**)

- **SH:** "the ask is the approval": agents cut builds and push them to itch
  as part of finishing work; only a hold order stops them.
- **PS, GB:** no export, package, upload or publish without an explicit ask;
  production server deploys are typed by the owner.
- **Standard:** W1 (the ask is the approval) for everything reversible; W3
  (explicit ask) for exports, uploads, deploys and public posts, **unless the
  game's `HANDOFF.md` grants standing release authority**. Two of three games
  gate releases, and a store push cannot be undone.
- **Owner to decide:** keep this per-game, or make SHAHANSHAH's standing
  authority the studio default once a game is in Early Access.

### C2. Which file holds the agent rules

- **SH:** `AGENTS.md` holds the rules; `CLAUDE.md` points to it.
- **GB:** `CLAUDE.md` holds the rules; `AGENTS.md` points to it.
- **PS:** both are substantial (`AGENTS.md` gates and model policy for Codex,
  `CLAUDE.md` overview and map).
- **Standard:** `AGENTS.md` holds the rules (the tool-neutral name Codex reads
  natively) and `CLAUDE.md` is the single line `@AGENTS.md`, which Claude Code
  expands on load, so both tools read one file with no extra step.
- **Existing games:** optional cleanup. PS would merge its two files.

### C3. `.import` line endings

- **PS, GB:** `*.import text eol=crlf`, because Godot on Windows rewrites
  sidecars CRLF; PS also wraps Linux Godot runs to convert back.
- **SH:** `* text=auto eol=lf`, `.import` included; a Windows clone that shows
  churn runs `git checkout -- '*.import'`.
- **Standard:** LF everywhere (SH). Most of the studio's machines are Linux,
  where Godot writes LF, so the CRLF pin creates the churn it was meant to
  stop and needs a wrapper to undo it. The three-command import audit (V4)
  stays mandatory either way.
- **Existing games:** no change required; switching a live repo renormalizes
  every sidecar in one commit.

### C4. Engineering agent

- **PS:** Codex is the sole engineering agent, with a Codex model ladder in
  `AGENTS.md` and `.codex/config.toml`.
- **SH, GB:** Claude Code leads; Codex makes images.
- **Standard:** Claude Code leads, Codex makes images. Model names change
  faster than rules, so new rules files describe tiers (small, middle,
  strongest) instead of naming models.

### C5. Engine language

- **PS:** GDScript only on `main` (`docs/TECH.md`: "no C# toolchain
  dependency"), standard Godot 4.7. Its C# port was done on a separate line
  and is not on `main`.
- **SH:** Godot 4.7.2 .NET with the `Qanat.*` modules; the owner's decision is
  that this is how the studio makes games now.
- **GB:** Godot 4.7.2 .NET with its own C# rules engine on the Qanat split.
- **Standard:** Qanat (Q1) for every new game.

### C6. Doc file names

| Doc | PS | SH | GB | Standard |
| --- | --- | --- | --- | --- |
| Asset ledger | `ASSET_MANIFEST.md` | `ASSETS.md` | `ASSET_MANIFEST.md` | `ASSET_MANIFEST.md` |
| Player changelog | `release/CHANGELOG.md` | `release/RELEASE_NOTES.md` | `release/CHANGELOG.md` | `release/CHANGELOG.md` |
| Design | `GDD.md` | `CAMPAIGN.md` and feature docs | `game-design.md` | `GDD.md` |
| Current state | none (retired) | `HANDOFF.md` | `HANDOFF.md` | `HANDOFF.md` |
| Tech | `TECH.md` | `DOTNET_PORT.md` | `ENGINE.md` | `ENGINE.md` |
| Doc index | map in `CLAUDE.md` | `docs/README.md` | map in `CLAUDE.md` | either |

Existing games keep their names; renaming breaks links for no gain.

### C7. CI

- **SH:** GitHub Actions on self-hosted runners, sharded, with a pre-push
  hook.
- **GB, PS:** no Actions; the rules file's check list is run by hand (GB has
  an unmerged release-pipeline branch).
- **Standard:** every new game starts with the template `tests.yml` and
  pre-push hook. Persian Strike and Galaxy Brain can adopt them when next
  active.

### C8. Version numbers and changelog voice

- **PS:** date-stamped headings (`2026.09.14 — <title>`) written for
  developers (what changed in the code and how it was checked).
- **SH:** `0.5.0-ea.N` / `0.5.0-demo.N`, tags `ea-v0.N`, player-facing notes
  led by the art.
- **GB:** `0.1.N`, player-facing.
- **Standard:** semantic versions in `config/version`, player-facing
  changelog only (two of three).

### C9. Website hosting

- **GitHub Pages:** reformatgames.com, persianstrike.com.
- **Cloudflare Workers:** playshahanshah.com, playgalaxybrain.com.
- **Standard:** static HTML either way. GitHub Pages for a static site
  (deploys on merge, no machine-bound login); a Worker only when the site
  needs server code or R2 next to it. Recorded per site in
  [WEBSITES.md](WEBSITES.md).

### C10. Site deploy approval

- **persian-strike:** the owner approves a preview before every deploy.
- **SH:** the site is rebuilt and deployed as part of finishing work.
- **Standard:** follows C1; a site deploy is a public change, so it needs an
  ask unless the game grants standing authority.

### C11. "Persian Strike is read-only"

- **SH** forbids its threads from writing to `Choppa2`: copy systems and
  assets from it with provenance, never commit to it.
- **Standard:** generalized. A game repository is written only by work on that
  game; other games copy from it with provenance (W7). Studio-wide fixes go
  through a thread for that game.

### C12. The engine's name

- **SH brand doc:** "Qanat" in prose; not "Qanat Engine" as a title.
- **GB:** "the Qanat Engine" in its README and rules file.
- **Standard:** SH's brand rule (B3). GB's wording can change when its docs are
  next edited.

## Decisions for the owner

### D1. Release approval

See C1.

### D2. Where shared Qanat code lives

The `Qanat.*` modules live inside SHAHANSHAH's repository and the
`rhicksrad/Qanat` repository holds only a README. The standard says a module
moves out once a second game uses it. Options when that happens:

1. **Recommended:** move `Qanat.*` and their tests to `rhicksrad/Qanat` and
   include it in each game as a git submodule at `engine/qanat/`, referenced
   by project path. No package feed to run, and each game pins a commit.
2. Publish packages to a private NuGet feed (GitHub Packages); cleaner
   versioning, but every machine and CI runner needs feed credentials.
3. Keep copying modules into each game (what happens now); simplest, but
   fixes drift apart.

### D3. The studio site's company name

reformatgames.com's footers read `© 2026 Reformat Games`, from a 5 November
change titled "Reformat Games has no LLC". SHAHANSHAH's `docs/LLC.md` records
the LLC as effective that day and filed on 8 November, and both games' exe
metadata now say `Reformat Games LLC`. Under B2 the footer would read
`© 2026 Reformat Games LLC`. This pull request leaves the site unchanged;
say the word and it is a one-line change per page.

### D4. Standards in a public repository

reformatgames.com is served from this public repository, so these standards
are public on GitHub (kept off the published site by `_config.yml`). They are
written to hold nothing private. If the owner would rather keep studio
process private, the `standards/` and `templates/` folders can move to a
private repository (the Qanat repository is one candidate) with a link left
here.
