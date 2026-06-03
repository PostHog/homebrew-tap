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
  version "1.1.0-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v1.1.0-cli/hogland_1.1.0-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "963f6208ae41478089d9d940e12494bb2f0f1a976def68a2ec188a98cf28d69d"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.1.0-cli/hogland_1.1.0-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "220bd5783be9d336ce4dfcc833079ece9488a25ed4c66e0204ea30521864471d"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v1.1.0-cli/hogland_1.1.0-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "0f6bfcebd7e6a1e7079e00b10420d2d5ad6276c3d534c02fb925ca945b62570b"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.1.0-cli/hogland_1.1.0-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "06909c71965d5c177b872c8cb2b20fa262cab043322a54964388d62c3ddc7d47"
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
