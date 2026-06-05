# typed: false
# frozen_string_literal: true

# This file is auto-rendered into PostHog/homebrew-tap by CI on `v*-cli`
# releases. Edit this template, not the rendered file in the tap.
#
# hogland lives in a private repo, so we can't fetch release tarballs via
# plain HTTPS. Instead we ride on the user's existing `gh auth login` via a
# tiny custom download strategy that shells out to `gh release download`.
# `depends_on "gh"` makes the prereq explicit.
require "download_strategy"

class GhCliDownloadStrategy < CurlDownloadStrategy
  # url format: gh://OWNER/REPO/TAG/ASSET
  def fetch(timeout: nil, **_options)
    _, _, owner, repo, tag, asset = url.split("/", 6)
    ohai "Downloading #{asset} from #{owner}/#{repo}@#{tag} via gh CLI"

    return if cached_location.exist?

    temporary_path.dirname.mkpath
    gh = Formula["gh"].opt_bin/"gh"
    system_command!(gh.to_s, args: [
      "release", "download", tag,
      "--repo", "#{owner}/#{repo}",
      "--pattern", asset,
      "--output", temporary_path.to_s,
      "--clobber"
    ], print_stderr: true)

    cached_location.dirname.mkpath
    FileUtils.mv(temporary_path, cached_location)

    symlink_location.dirname.mkpath
    FileUtils.ln_s(cached_location.relative_path_from(symlink_location.dirname), symlink_location, force: true)
  end
end

class Hogland < Formula
  desc "PostHog hogland CLI — manage hogboxes, snapshots, and devboxes"
  homepage "https://github.com/PostHog/hogland"
  version "1.2.1-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v1.2.1-cli/hogland_1.2.1-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "670f66c5910c5386d98c20f52efa824bf6d4cbc422c451a5858b6e36baa6e996"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.2.1-cli/hogland_1.2.1-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "58dbd130b605cdc77b5b2e234b5b204b6866895950c73d6873bb9e379b21ac19"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v1.2.1-cli/hogland_1.2.1-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "a265d5b34aac3b667ee1630aec66e7c234119ba8749e8258d7a8f95e68097d6f"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.2.1-cli/hogland_1.2.1-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "ec50062e399bd443f8ac2b2e7639b9eaa5e2a72d68216f1bf7e225cbda482339"
    end
  end

  def install
    bin.install "hogland"
    generate_completions_from_executable(bin/"hogland", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hogland version")
  end
end
