# homebrew-tap

Homebrew formulae for PostHog developer tools.

```bash
brew install posthog/tap/phrocs    # PostHog dev process runner
brew install posthog/tap/hogland   # hogland CLI (hogboxes, snapshots, devboxes)
```

`hogland` still lives in a private repo, so its formula shells out to `gh` —
run `gh auth login` once and you're good.

## How formulae get updated

Both formulae are **rendered into this repo by CI in their source repo**, not
edited here. Don't hand-edit a `Formula/*.rb` file expecting the change to
stick — the next release will overwrite it.

| Formula | Source repo | Workflow | Template |
|---------|-------------|----------|----------|
| `phrocs` | `PostHog/posthog` | `.github/workflows/build-phrocs.yml` | `tools/phrocs/Formula/phrocs.rb` |
| `hogland` | `PostHog/hogland` | `.github/workflows/release.yml` | `homebrew/hogland.rb.tmpl` |

Auth: source-repo workflows mint a scoped install token via the org-level
GitHub App `GH_APP_HOMEBREW_TAP_RELEASER` (client id + private key live as
selected-repo org secrets). No PATs.
