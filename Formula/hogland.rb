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
  version "1.7.2-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v1.7.2-cli/hogland_1.7.2-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "47a1082856ea07c03ac04df9c8611a1326da5188d626f7ee67bd6bbf3848384c"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.7.2-cli/hogland_1.7.2-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "a382c513b2d56782abc78523e882b15ed403a36492664d8540e73845899bac89"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v1.7.2-cli/hogland_1.7.2-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "1b681de1c6aed970aed98914057524f4acf3c782041b588cfce83e14f3a1976e"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.7.2-cli/hogland_1.7.2-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "7781a65f23ea3a7cd2f08e7b43618ea3989816c4f7817752b6989406bf971d6c"
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
