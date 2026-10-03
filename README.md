# homebrew-tap

Homebrew formulae and casks for PostHog developer tools.

```bash
brew install posthog/tap/phrocs    # PostHog dev process runner
brew install posthog/tap/hogland   # hogland CLI (hogboxes, snapshots, devboxes)
brew install --cask posthog/tap/postpile   # PostPile, macOS app for GitHub PR notifications (alpha)
```

`postpile` is an alpha for Apple silicon, signed and notarized. It needs `gh`
and `claude` installed and logged in. From 0.16.0 it updates itself (the cask
says `auto_updates true`); `brew upgrade --cask postpile` works too.

`hogland` still lives in a private repo, so its formula shells out to `gh` —
run `gh auth login` once and you're good.

## How formulae and casks get updated

All of them are **rendered into this repo by CI in their source repo**, not
edited here. Don't hand-edit a `Formula/*.rb` or `Casks/*.rb` file expecting the change to
stick — the next release will overwrite it.

| Formula / cask | Source repo | Workflow | Template |
|---------|-------------|----------|----------|
| `phrocs` | `PostHog/posthog` | `.github/workflows/build-phrocs.yml` | `tools/phrocs/Formula/phrocs.rb` |
| `hogland` | `PostHog/hogland` | `.github/workflows/release.yml` | `homebrew/hogland.rb.tmpl` |
| `postpile` (cask) | `PostHog/postpile` | `.github/workflows/release.yml` | `homebrew/postpile.rb.tmpl` |

Auth: source-repo workflows mint a scoped install token via the org-level
GitHub App `GH_APP_HOMEBREW_TAP_RELEASER` (app id + private key live as
secrets in each source repo's `homebrew-tap` environment, limited to
release tags). No PATs.
