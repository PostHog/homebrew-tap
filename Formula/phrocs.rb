# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
class Phrocs < Formula
  desc "PostHog development process runner"
  homepage "https://github.com/PostHog/posthog/tree/master/tools/phrocs"
  version "1.0.8"

  on_macos do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.8/phrocs-darwin-amd64"
      sha256 "aa42a4f6f3faeaa48c9e149665bf8746dd21c9479a913189574518d07e96bcca"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.8/phrocs-darwin-arm64"
      sha256 "35ffdd5be99ceb63314361969e792a037b3bf3c50bacbb5e148826434d068271"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.8/phrocs-linux-amd64"
      sha256 "03b75c341283b774a1b483abb40581b8eb4b875c67a8a3d9a21fbba247efeda6"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.8/phrocs-linux-arm64"
      sha256 "23c1f817b309950f1a25b088316a6a2be6de8c2076842a34c5828d1fb2ffc643"
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
