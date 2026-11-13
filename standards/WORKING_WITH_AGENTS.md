# Working with agents

Most of the studio's code, docs and art pipelines are run by AI agents (Claude
Code and Codex) on the owner's behalf. This page is how that work is
organised so every game behaves the same way. Policy IDs: W1–W12 in
[POLICIES.md](POLICIES.md).

## Who does what

- **Claude Code leads** engineering: the conversation, architecture,
  implementation, integration, diff review, verification and the final
  report. It may route a scoped subtask to a cheaper model (inventories and
  counts to the smallest, well-scoped work to the middle tier, visual design
  and hard architecture to the strongest), and owns the integration and the
  check afterwards. **[GB] [SH]**
- **Codex CLI generates every image** from a brief file kept in the repo
  ([ASSETS.md](ASSETS.md#generated-images)). Persian Strike also runs Codex as
  its engineering agent; see [CONFLICTS.md](CONFLICTS.md) C4.
- An explicit model choice from the owner beats any routing default.

A worker brief names the objective, the files it may touch, the entry points,
the invariants and the check that proves success. The worker returns changed
paths, evidence and open doubts. One worker at a time unless the owner asks
for parallel work.

## Approvals

The default is **the ask is the approval** (W1). An agent finishes what was
asked end to end and decides routine choices itself. It asks only for a real
blocker (W2), as one question, with a one-line script when a script would fix
it, and keeps doing everything that does not depend on the answer.

Steps that cannot be undone wait for an explicit ask (W3):

| Step | Default | Who may grant standing authority |
| --- | --- | --- |
| Playable export (`--export-release`, anything in `build/`) | Explicit ask | The game's `HANDOFF.md` |
| Store upload (butler, Steam) | Explicit ask | The game's `HANDOFF.md` |
| Production deploy (Workers, D1 migrations, live servers) | Explicit ask, typed by the owner | Not delegated |
| Public posts (devlogs, YouTube, social) | Owner sees the draft first | Not delegated |
| Money, accounts, legal filings | Owner only | Not delegated |
| Merging a green pull request | Allowed | — |

A game may set a different line in its own rules file. SHAHANSHAH grants
standing release authority (agents cut and push itch builds); Persian Strike
and Galaxy Brain do not. That split is recorded as
[CONFLICTS.md](CONFLICTS.md) C1.

Hold orders ("no itch pushes for now", "English voice only for now") stand
until the owner lifts them (W4). Each game lists its live hold orders in
`HANDOFF.md`.

## Codewords

| Codeword | Meaning | Never authorizes |
| --- | --- | --- |
| **`tie it off`** **[PS] [GB]** | Finish the active approved scope: resolve loose wiring; update docs, changelog, credits and provenance; delete obsolete regenerable scratch output; run the focused checks and import hygiene; commit, push the branch and confirm the local and remote SHAs match | An export, publication, release, deleting source or provenance, unrelated backlog work |
| **"Do the thing"** (exact wording in SHAHANSHAH's `HANDOFF.md`) **[SH]** | Finish end to end including the deploy or store push, with no questions | Lifting a hold order |

A new game copies both into its rules file.

## Threads and sessions

- One thread per piece of work, titled by the goal. A game that runs threads
  on the owner's own machines starts the title with the machine name.
  **[SH]**
- A thread that finishes takes the next item in its area (open work in
  `HANDOFF.md`, open issues, its own follow-ups) unless the owner said to stop.
  While it waits on CI or a lock it works on something else. **[SH]**
- Project memory does not move between accounts. Everything a new account or
  session would have to ask again goes into the game's `docs/HANDOFF.md`,
  which is the durable replacement for agent memory. **[SH]**
- Machine-specific facts (paths, which machine merges, which runs timing,
  where logins live) belong in the game's private `HANDOFF.md`, never in this
  public repository.

## Context discipline

- Read the bootstrap (`AGENTS.md`/`CLAUDE.md`) once per task. Open subject
  docs only for the part of the task they govern; the documentation map says
  which.
- Find the symbol, then read the function, its callers and its state owner.
  Use deterministic tools (search, counts, scripts) before reading whole files.
- Save full verification logs to files and report the exit status, the
  required markers and the failures. A truncated log is not a complete check.
- Start a fresh task when the subject changes, carrying only current
  constraints, paths, evidence and remaining work.

## Handoff checklist

Before reporting a task done:

1. Re-read the request and every changed file.
2. Run the checks the change calls for ([VERIFICATION.md](VERIFICATION.md)),
   including import hygiene if Godot ran.
3. Update the docs the change makes stale, `HANDOFF.md` if the state moved,
   and the changelog if players will notice.
4. Say what was reused or why nothing fit (W7).
5. State the evidence by kind: static, focused test, visual inspection, play,
   export, publication. One does not imply another (V6).
6. Confirm every export, upload or deploy had its required authorization.

## Maintaining agent guidance

Keep durable constraints in the rules file and task detail in linked docs.
When a rule changes, delete the rule it replaces in the same edit; never keep
both. Prompts state the target, scope, constraints and the evidence that
proves completion, and leave routine implementation choices to the agent.
