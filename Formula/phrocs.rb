# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
class Phrocs < Formula
  desc "PostHog development process runner"
  homepage "https://github.com/PostHog/posthog/tree/master/tools/phrocs"
  version "1.0.7"

  on_macos do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.7/phrocs-darwin-amd64"
      sha256 "1d5f128a1844a6403dfe7cbcba553c3e3200c3fefb05a0b501a5b7c7538287f0"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.7/phrocs-darwin-arm64"
      sha256 "305dfee6af46f990b53a4cbe6c2b6d149ee6a24deff089cadbb44617c046e746"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.7/phrocs-linux-amd64"
      sha256 "361fad25399f027b1d7d8049183c69d22e673e22a7d1d272cabd0502529426a0"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.7/phrocs-linux-arm64"
      sha256 "874beb24c655d79a22f1c8b0efd6da4695784cb2747897838bde41206321cca5"
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
