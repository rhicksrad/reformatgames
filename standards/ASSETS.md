# Asset pipeline

Where art, models, audio and fonts come from, how they are licensed and
recorded, and how generated art is made. Policy IDs: A1–A7 in
[POLICIES.md](POLICIES.md).

## Order of preference

1. **Reuse** an asset already imported in this game, or in another studio game
   with its provenance carried over (W7).
2. **A licensed external asset** (A1): Sketchfab, Poly Haven, Kenney,
   Freesound, OpenGameArt, Google Fonts and the other sources already in the
   manifests.
3. **Generated 2D art** from Codex, for illustrations, UI art, paintings and
   concept references.
4. **Project-authored** geometry or procedural art, last, and only after the
   first three were checked. Small period-specific pieces are fine; note them
   in the manifest.

Never a primitive box, cylinder or sphere stand-in for a building, vehicle or
person in shipped content. **[PS]**

## Licences

| Licence | Use |
| --- | --- |
| CC0, public domain, original | Default |
| CC-BY 3.0 / 4.0 | Allowed with attribution; no separate approval |
| SIL OFL 1.1 (fonts), MIT, BSD, Apache-2.0 (code, tools, voices) | Allowed with the licence text kept |
| CC-BY-SA, any NC or ND, "free for personal use", unknown | Owner's approval required; normally refused |

GPL tools may be used to make content (Blender add-ons, espeak, Piper) as long
as the tool itself does not ship. CC-BY content must not ship behind DRM or
pack encryption (A7).

## Recording an asset

For every external or generated asset (A3):

- **Beside the asset:** `ATTRIBUTION.md` (external) or `PROVENANCE.md` /
  `PROVENANCE.json` (generated), naming the author, source URL, licence,
  retrieval date and what was changed.
- **The unchanged source** (archive, GLB, licence file) is kept (A4) and marked
  byte-for-byte in `.gitattributes` when it is text.
- **`docs/ASSET_MANIFEST.md`:** one append-only row per shipped asset: what it
  is, path, origin, licence, unchanged-source bytes, SHA-256. Derived files
  (resized JPEGs, atlases) inherit their source's row.
- **`CREDITS.txt` and the in-game credits:** every CC-BY and other
  attribution-required asset, by title, author and source. A test or the
  release script checks every attribution-required folder has a credit row.

A credit gap is a shipping defect: fix it in the next build.

## Sketchfab and other downloads

- Use the official API (`/v3/models/{uid}` for metadata, `/download` for the
  file). The token comes from an environment variable or the machine's secret
  file, read into a task-scoped variable without printing it (A5).
- Never echo a token, enable shell tracing around it, write it into a
  repository, or keep a signed download URL.
- Keep the exact model selected. A different model or pack substitute needs
  the same review as a new pick.
- Import through the game's wrapper (`godot --headless --path . --import`)
  before any direct `preload()`; the new `.import` sidecars are part of the
  integration.
- Downloads stage under ignored `.dev/downloads/`, never as game content.

## Generated images

The studio generates 2D art with the **Codex CLI** (`codex exec`, its
built-in image tool), not with metered APIs (W8).

- **Briefs are files in the repo** (`docs/art-brief.md`,
  `docs/ui-art-brief.md`, and per-set briefs). Pass Codex the file
  ("Read docs/art-brief.md and carry out every instruction in it"); a long
  multi-line brief passed as a shell argument gets truncated.
- **A shared style block** per game (style bible) is prepended to every brief.
- **Fixed sizes per use** (Galaxy Brain: card art 1024x1536 portrait, ships
  and paintings 1536x1024, backdrops 16:9) and fixed path rules the game's art
  resolver understands, checked by a script.
- **No text in the image, original designs only.** Review every image for
  stray lettering and third-party look-alikes before use (A6, B7).
- **Variants are rendered from their base image** attached as the reference.
- **Masters stay out of git.** Full-size PNGs go to the art archive (an R2
  bucket or the rendering machine's archive); the repo ships web-sized
  derivatives (720 px JPEG or lossy WebP) built by a script.
- **Provenance** for each kept image: prompt, sha256, source path, in
  `PROVENANCE.json` beside it or a manifest row. The pre-push hook and static
  audit refuse a new generated image without one.
- Concept references (used to design a building or scene) are kept distinct
  from runtime evidence.

## Audio

- Music and SFX follow the same licence rules and records. Prefer CC0
  (Kenney, Freesound CC0) and original synthesized SFX.
- Large streamed audio (narration) is served from Cloudflare R2 under a
  studio domain, never from a personal account's address. The source repos for
  voice and music stay the source of truth. **[SH]**
- Voice: locally run open models with permissive licences only (Kokoro
  Apache-2.0, Piper MIT, Chatterbox MIT); record the voice and dataset licences
  in the audio provenance.

## Fonts

Open licences only (SIL OFL from google/fonts), kept unchanged with their
licence, recorded in the manifest. Fonts used only in baked images are never
shipped as live fonts.

## Shipping size

- Lossy WebP or JPEG for large 2D art; check before a release with a script
  that would still convert anything (SHAHANSHAH
  `tools/release/lossy_2d_art.py`).
- List what fills a pack before release (`tools/release/pck_list.py`).
- Windows packs ship beside the exe when they would push it past 4 GiB.
