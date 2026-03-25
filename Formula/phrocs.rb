# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
class Phrocs < Formula
  desc "PostHog development process runner"
  homepage "https://github.com/PostHog/posthog/tree/master/tools/phrocs"
  version "1.0.3"

  on_macos do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.3/phrocs-darwin-amd64"
      sha256 "bd0de868df95c01d3b5f695a31107b631592af15e9960dc2710b0ea938519d75"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.3/phrocs-darwin-arm64"
      sha256 "c90cb63ffd1dc6d671d8f20372e776ff31329fd52387aa58401e42c86db982e6"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.3/phrocs-linux-amd64"
      sha256 "b0d938c2bbee634617f4c1e7d96ee64c8fef0dc71546400102611e6fc478e2b2"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.3/phrocs-linux-arm64"
      sha256 "6be3007ebad753b005ee2bfe0e090bbc577cd0b7830f33bbd2def4885c2402e6"
    end
  end

  def install
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    os = OS.mac? ? "darwin" : "linux"
    bin.install "phrocs-#{os}-#{arch}" => "phrocs"
  end

  test do
    assert_match "phrocs #{version}", shell_output("#{bin}/phrocs --version")
  end
end
