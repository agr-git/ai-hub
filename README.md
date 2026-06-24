# AutonomIA+ · AI Hub

A single-file command center for tracking every active project — what it is, where it lives locally, its GitHub repo, and its current status.

**Live:** deployed as a subpage of the Story Engine site at `/hub/` (GitHub Pages / nginx serves the Story Engine `docs/` folder).

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
autonomia-linkedin-story-engine/docs/hub/index.html   ← deployed copy (served at /hub/)
ai-hub/index.html                                      ← source of truth (this repo)
```

When you change the hub here, sync the file into `docs/hub/` and commit the Story Engine repo to publish.

---

Built with Claude Code.
