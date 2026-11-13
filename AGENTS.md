# Reformat Games: agent rules for this repository

This repository is two things:

1. **reformatgames.com**, the studio site: the HTML, `styles.css`, `media/`,
   `CNAME`, `robots.txt`, `sitemap.xml` and `404.html` at the top level,
   published by GitHub Pages from `main`.
2. **The studio standards**: [standards/](standards/README.md) (the rules every
   game keeps, the policy list, the conflicts between repos),
   [templates/new-game/](templates/new-game/) (the starting copy of a new
   game) and [tools/new_game.sh](tools/new_game.sh).

`CLAUDE.md` imports this file.

## Rules

- **The repository is public.** Nothing here may name a person, an email, an
  address, a home path, a machine, a token location or an account id. Those
  belong in each game's private `docs/HANDOFF.md`.
- **Don't break the site.** A change to the standards never touches the site's
  HTML, CSS or media. `_config.yml` keeps `standards/`, `templates/`, `tools/`
  and the Markdown at the top level out of the published site; any new
  top-level folder or Markdown file that is not part of the site is added to
  its `exclude` list in the same change.
- **Site changes** follow [standards/WEBSITES.md](standards/WEBSITES.md): static
  HTML, the existing `styles.css`, current head tags and structured data,
  `sitemap.xml` updated. A merge to `main` deploys the site, so a site change
  is a public change: it needs the owner's ask. After it merges, check the
  live page directly.
- **Standards changes** follow [standards/README.md](standards/README.md):
  current state only, the policy list and the detailed page changed together,
  and a game that deliberately differs recorded in
  [standards/CONFLICTS.md](standards/CONFLICTS.md).
- **Template changes** keep `tools/new_game.sh` working: run it into a scratch
  directory and check that no `GAME_NAME`, `GameNs` or `game-slug` is left.
- Never push to `main`. Branch, pull request, merge.
