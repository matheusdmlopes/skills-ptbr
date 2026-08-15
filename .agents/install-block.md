# The canonical install block

One install story, one wording. `README.md` and `NOTICE` must say **this** and nothing else. Change it here first, then propagate.

**This pt-BR fork does not ship a Claude Code plugin listing.** Upstream (`mattpocock/skills`) is in Claude Code's official marketplace under the name `mattpocock-skills`; this fork has no equivalent listing, and `.claude-plugin/` here is kept byte-for-byte identical to upstream (still branded `mattpocock-skills`) rather than adapted — see `NOTICE`. Installing it as a plugin would install upstream's English skills under this fork's name, which is worse than not offering the route at all. So there is exactly one documented path, for every agent including Claude Code:

<canonical-block name="skills-sh-whole-set">

```bash
npx skills@latest add matheusdmlopes/skills-ptbr
```

Pick the skills you want, and which coding agents to install them on. **The installer lets you choose which skills to take — make sure `setup-matt-pocock-skills` is one of them.**

</canonical-block>

…and the single-skill form wherever one skill is named on its own:

<canonical-block name="skills-sh-one-skill">

```bash
npx skills@latest add matheusdmlopes/skills-ptbr --skill=<name>
```

```bash
npx skills@latest update <name>
```

</canonical-block>

`skills@latest` is the pinned spelling in both. To switch language, reinstall from the other origin (`mattpocock/skills` for English) — see `NOTICE`.

## Not the install story

`.claude-plugin/marketplace.json` makes the repo its own single-plugin marketplace (`/plugin marketplace add matheusdmlopes/skills-ptbr`, then `/plugin install mattpocock-skills@mattpocock`). Untouched from upstream, so it still installs upstream's identity, not a pt-BR one. Kept only because touching `.claude-plugin/` is out of this fork's scope (see `NOTICE`); **not** documented to users, and arguably shouldn't be used as-is.
