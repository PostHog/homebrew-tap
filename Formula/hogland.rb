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
  version "0.7.0-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v0.7.0-cli/hogland_0.7.0-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "93d9497c6a9e89ba0f02d3b6a66d099d8994c886a6886863cb2e91dd19e22ba1"
    end
    on_arm do
      url "gh://PostHog/hogland/v0.7.0-cli/hogland_0.7.0-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "6004c7c5b58c7e4a0afadd28a4db88766e8d18921e785b9f9949017f1fb5b915"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v0.7.0-cli/hogland_0.7.0-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "60b168c7a5f28ae3a3781a1c932b7f08d6b9a68a522277718145bfeb67ce3d08"
    end
    on_arm do
      url "gh://PostHog/hogland/v0.7.0-cli/hogland_0.7.0-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "80eea1042d0ddf017ba31dc4a45c4a2bd5c08800583c825617d29139e570a464"
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
