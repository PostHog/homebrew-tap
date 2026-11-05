# typed: false
# frozen_string_literal: true

# Rendered into PostHog/homebrew-tap as Casks/sizeberg.rb by .github/workflows/release.yml on
# v* tags. Edit this template, not the rendered file in the tap; the next release overwrites it.
#
# The first block in the caveats, between its two marker lines, is for ad-hoc signed builds only.
# The workflow deletes the whole block for a Developer ID signed and notarized build, and only the
# two marker lines for an ad-hoc one. Don't write the marker names anywhere else in this file.
cask "sizeberg" do
  version "0.1.5"
  sha256 "8ac4cc774b7a37f5da663c6bfc1070d90724626e3c410caf6d491592d2f0179b"

  url "https://github.com/PostHog/sizeberg/releases/download/v#{version}/SizeBerg-#{version}-mac-arm64.zip"
  name "SizeBerg"
  desc "Shows what deleting worktrees, build output and caches really frees on APFS"
  homepage "https://github.com/PostHog/sizeberg"

  # Developer ID builds update themselves with Sparkle, so brew leaves an app that is already newer
  # than this cask alone.
  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :sequoia"

  app "SizeBerg.app"
  # The CLI lives inside the app, so both come from one download.
  binary "#{appdir}/SizeBerg.app/Contents/Helpers/sizeberg"

  uninstall quit: "com.posthog.sizeberg"

  # Everything SizeBerg writes: the scan cache and last report (shared with the CLI), Sparkle's
  # downloads and HTTP storage, and the window sizes and update settings macOS keeps.
  # local.sizeberg is the bundle ID of builds from before the first release.
  zap trash: [
    "~/Library/Caches/com.posthog.sizeberg",
    "~/Library/Caches/sizeberg",
    "~/Library/HTTPStorages/com.posthog.sizeberg",
    "~/Library/Preferences/com.posthog.sizeberg.plist",
    "~/Library/Preferences/local.sizeberg.plist",
    "~/Library/Saved Application State/com.posthog.sizeberg.savedState",
  ]

  caveats <<~EOS
    SizeBerg finds the folders in your home folder that hold git repositories.
    If they are in Documents, Desktop or Downloads, macOS asks once for access.

    Remove its scan cache and settings too with: brew uninstall --zap sizeberg
  EOS
end
