# GAME_NAME image generation

Every generated image comes from the Codex CLI from a brief file in this
repository, following the studio pipeline
(<https://github.com/rhicksrad/reformatgames/blob/main/standards/ASSETS.md#generated-images>).

- Briefs: `docs/art-brief.md` (start it with the shared style block).
- Sizes and paths: <per use>.
- Run: `codex exec -s workspace-write -C <repo> "Read docs/art-brief.md and carry out every instruction in it."`
- Review every image for stray text and lookalikes; record it in
  [ASSET_MANIFEST.md](ASSET_MANIFEST.md) and keep its prompt in
  `PROVENANCE.json` beside it. Full-size masters stay out of git.
