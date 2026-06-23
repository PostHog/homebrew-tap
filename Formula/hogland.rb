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
  version "1.3.0-cli"

  depends_on "gh"

  on_macos do
    on_intel do
      url "gh://PostHog/hogland/v1.3.0-cli/hogland_1.3.0-cli_darwin_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "7ddc1e8447e2de081a42eeda26d26964af34cb0ff67094079294042d5a927e75"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.3.0-cli/hogland_1.3.0-cli_darwin_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "7f02ae93d42d988f15bab73eb15c86bc940d192c1db7bbad2053237c883c2a44"
    end
  end
  on_linux do
    on_intel do
      url "gh://PostHog/hogland/v1.3.0-cli/hogland_1.3.0-cli_linux_amd64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "fa1cc7fac1110ff4ea60d655e2aefc0eea2076e6984810ba00edfcd971e54ada"
    end
    on_arm do
      url "gh://PostHog/hogland/v1.3.0-cli/hogland_1.3.0-cli_linux_arm64.tar.gz",
          using: GhCliDownloadStrategy
      sha256 "6b0cff3ec071f5ac57778efe20dc8188feb35e433d1dc5f85371f46493ad711a"
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
