# AutonomIA+ · AI Hub

A single-file command center for tracking every active project — what it is, where it lives locally, its GitHub repo, and its current status.

**Live:** deployed as a session-gated subpage of the Story Engine site at `/dashboard/hub/` (the box's nginx serves it from the Story Engine `docs/` volume behind login). The site is baked into the engine Docker image, so publishing requires a container rebuild on the VPS — not just a `git pull`.

## What it is

- **One static `index.html`** — no build step, no dependencies. Open it in a browser.
- **AutonomIA+ branding** — Clawd mascot, dark theme, Poppins / Lora / JetBrains Mono, orange `#d97757` accent, light/dark toggle. Matches `autonomia-linkedin-story-engine/execution/_branding.py`.
- **Filter + search** — by status (Active / In Progress / Paused / Archive) and free-text.
- **Stats banner** — active, in-progress, repo count, total tracked.

## Keeping it current

The project list is a plain JS array near the top of the `<script>` block in `index.html`:

```js
const projects = [
  { name:"…", status:"active", updated:"2026-06-23",
    desc:"…", tags:["…"], folder:"…", repo:"repo-name" /* or null */ },
  …
];
```

- `status`: `active` | `progress` | `paused` | `archive`
- `repo`: the GitHub repo name under `github.com/agr-git`, or `null` if none
- `updated`: last-activity date (`YYYY-MM-DD`)

Edit the array, save, refresh. To re-deploy, copy `index.html` into the Story Engine repo at `docs/hub/index.html`.

## Deployment

This repo is the **canonical source**. The live copy lives inside the Story Engine repo so it can reuse that domain:

```
autonomia-linkedin-story-engine/docs/hub/index.html   ← deployed copy (gated, served at /dashboard/hub/)
ai-hub/index.html                                      ← source of truth (this repo)
```

When you change the hub here, sync the file into `docs/hub/` and commit the Story Engine repo to publish.

---

Built with Claude Code.
