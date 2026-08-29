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
  version "1.6.0-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v1.6.0-cli/hogland_1.6.0-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "093e3fa086ecfd693e274ddbd6fde772d0dc6c29cc841a4f15896ee006a404db"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.6.0-cli/hogland_1.6.0-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "dba3b7d80fa4e8a7a827358929cec2820ba4781336407d00606f7daafa561c46"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v1.6.0-cli/hogland_1.6.0-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "ae17ceaede3c9d8aff6ae8579c7484d6ef39417407eb5a42473f0452d0ced8b0"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.6.0-cli/hogland_1.6.0-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "41b97ca196c258b106f34180a2097f64f19f04e9eaae09db0ef467f465d2556f"
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
