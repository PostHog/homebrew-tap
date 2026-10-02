# typed: false
# frozen_string_literal: true

# Rendered into PostHog/homebrew-tap as Casks/postpile.rb by
# .github/workflows/release.yml on v* tags. Edit this template, not the
# rendered file in the tap; the next release overwrites it.
#
# The first block in the caveats, between its two marker lines, is for ad-hoc
# signed builds only. The workflow deletes the whole block for a Developer ID
# signed and notarized build, and only the two marker lines for an ad-hoc one.
# Don't write the marker names anywhere else in this file.
cask "postpile" do
  version "0.15.2"
  sha256 "d4ece2fffb1b109558e030d98a0bbe727e944be6630cd159a03b6cac2dc8fbd9"

  url "https://github.com/PostHog/postpile/releases/download/v#{version}/PostPile-#{version}-mac-arm64.zip"
  name "PostPile"
  desc "Turns GitHub PR notifications into agent-maintained topics"
  homepage "https://github.com/PostHog/postpile"

  depends_on arch: :arm64
  depends_on macos: :monterey

  app "PostPile.app"
  # Read-only MCP server for other agents; the script follows this symlink back into the app.
  binary "#{appdir}/PostPile.app/Contents/Resources/postpile-mcp"

  zap trash: [
    "~/.config/postpile",
    "~/Library/Application Support/PostPile",
    "~/Library/Logs/PostPile",
    "~/Library/Preferences/com.posthog.postpile.plist",
    "~/Library/Saved Application State/com.posthog.postpile.savedState",
  ]

  caveats <<~EOS
    PostPile needs the GitHub CLI and the Claude Code CLI, both installed
    and logged in:

      brew install gh && gh auth login
      curl -fsSL https://claude.ai/install.sh | bash && claude auth login

    Let other agents ask PostPile about your PRs (read-only):

      claude mcp add postpile -- postpile-mcp

    Update later with: brew upgrade --cask postpile
  EOS
end
