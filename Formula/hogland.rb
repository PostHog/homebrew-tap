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
  version "1.0.0-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v1.0.0-cli/hogland_1.0.0-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "207c86af5613e0128f08ff939e81e1f14561ce964706b17d83aa5095084a4894"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.0.0-cli/hogland_1.0.0-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "7c6f687d07438fbb4d46caf4c7b6f9109af209471686b30254af03059917aced"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v1.0.0-cli/hogland_1.0.0-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "fa71d2c1d02da6832cb6b6331921d6f6ef5b67db86cb1c4cfd2d561ca9b7e66a"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.0.0-cli/hogland_1.0.0-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "aace6eaef0bd91c5266cd5e42848c36ce1cf146a452864612e13eaa00d82434c"
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
