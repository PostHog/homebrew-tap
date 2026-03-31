# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
class Phrocs < Formula
  desc "PostHog development process runner"
  homepage "https://github.com/PostHog/posthog/tree/master/tools/phrocs"
  version "1.0.6"

  on_macos do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.6/phrocs-darwin-amd64"
      sha256 "599c487e7285e44dcd8df382b2da0a2c9ec82b5ab0c26b92ce565166e691d2c6"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.6/phrocs-darwin-arm64"
      sha256 "d44861dff20624a186c480d6c831bcc731757757eae4d221dcfa2b5453e9861d"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.6/phrocs-linux-amd64"
      sha256 "1d8a8d307c34889f05d81131935593b48e0af60f0e57911fea33eaa232d44317"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.6/phrocs-linux-arm64"
      sha256 "653e88727fa6a4a5681cecbbf6ace4b689e673e9658c9d5586c418d0f2f4f96e"
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
