# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
class Phrocs < Formula
  desc "PostHog development process runner"
  homepage "https://github.com/PostHog/posthog/tree/master/tools/phrocs"
  version "1.0.10"

  on_macos do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.10/phrocs-darwin-amd64"
      sha256 "8ad5a3ff4a9504ae75b7521ffcc06f8d3f6885a930675101168903b835180f05"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.10/phrocs-darwin-arm64"
      sha256 "9c2561919c92a397ae4a06d87c40dabace1741f4c709c27ea7907434b16ef30f"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.10/phrocs-linux-amd64"
      sha256 "eb50a3d4451a7fca0180f57e0e86baf8524859171d116ad3538441e759fc81ba"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.10/phrocs-linux-arm64"
      sha256 "45a90e852b04183b4d99ec408e4c0acd8a8fa0069e27c84a3a28cc43e4106f4f"
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
