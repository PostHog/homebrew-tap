# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
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
  version "0.6.0-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v0.6.0-cli/hogland_0.6.0-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "7515a92b388e2a7b0af7d290875bcd8a1e453c436b8caff803272ba932299441"
    end
    on_arm do
      url "gh://PostHog/hogland/v0.6.0-cli/hogland_0.6.0-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "91cc5708e8ef8191a7ed8d4c142231e37add91834860671cf889c9cc0e580181"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v0.6.0-cli/hogland_0.6.0-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "5fc00cb5bd97bb97c06030fbaf821fefae9827ea9265567560e25683bdc378d1"
    end
    on_arm do
      url "gh://PostHog/hogland/v0.6.0-cli/hogland_0.6.0-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "ad2c266aae0fb912697efdd0e95af3a0786817947c4a5b2ec4f70950efd6b00c"
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
