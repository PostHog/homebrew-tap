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
  version "1.2.0-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v1.2.0-cli/hogland_1.2.0-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "91c497c48fb3686dd68e83ee8a0e8730a48eaf897bf528d82709c6b340fafe93"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.2.0-cli/hogland_1.2.0-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "75dad908d13a83f0b34645b330714733c67d4d3cf81d09c2ae49c08ff1fb8392"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v1.2.0-cli/hogland_1.2.0-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "982408d22dd5b5349275319a325c2526cb4a45b2072cf63b96c5b7695e8aa3db"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.2.0-cli/hogland_1.2.0-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "70a244b651a2c15315614ed5e25edd74755a2bc64014f607e346ad09a3437f67"
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
