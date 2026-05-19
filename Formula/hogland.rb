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
  version "0.8.0-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v0.8.0-cli/hogland_0.8.0-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "1dec620e11f43b4485bfac5b3cbedcf8b157eb869df6df16e8969170f748b442"
    end
    on_arm do
      url "gh://PostHog/hogland/v0.8.0-cli/hogland_0.8.0-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "5358349ecb619de09a1bf154667a3713b17721f9fa78afe1ab6432ff4957e2a3"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v0.8.0-cli/hogland_0.8.0-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "835f0b0644e634ce2cb2b81fef9247c82d4a1a07aaf09ec4d01c5f8a7e4a432b"
    end
    on_arm do
      url "gh://PostHog/hogland/v0.8.0-cli/hogland_0.8.0-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "7e8488c2837bc9345d7e3732b5ddf5d784598529c0cdd7b05c6beb2cef04ec32"
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
