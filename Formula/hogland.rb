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
  version "1.7.1-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v1.7.1-cli/hogland_1.7.1-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "528bdeaede568392a003e3432c9eaef714fa000b25a5de66bba7ef76eebf162f"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.7.1-cli/hogland_1.7.1-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "33c1f7f311d31570f0d4244e5f5b10421f31fda4719793b39e377f19ee464204"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v1.7.1-cli/hogland_1.7.1-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "3d8d845ea06cfffaff3be85c28d76e7fdb80359d0795e16cc4c4ea61e454f2b3"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.7.1-cli/hogland_1.7.1-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "1b092172ecc9d01c4e59d89e4f2667fd200916c98bd29278cae2cfe678561289"
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
