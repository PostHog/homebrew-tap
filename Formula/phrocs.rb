# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
class Phrocs < Formula
  desc "PostHog development process runner"
  homepage "https://github.com/PostHog/posthog/tree/master/tools/phrocs"
  version "1.0.2"

  on_macos do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.2/phrocs-darwin-amd64"
      sha256 "a9fd2963d955703417db131c28c2e524b0f586878628212b63ccf281dc75e931"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.2/phrocs-darwin-arm64"
      sha256 "bbfd994fa4c5b556e4d27a41a95837a6f319b3c6a3b2e05328e3714e91989089"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.2/phrocs-linux-amd64"
      sha256 "71626e0d3e1a1aa8b2bffc78f06024a667098689d46efefbb53b9b603d6db620"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.2/phrocs-linux-arm64"
      sha256 "312a4af133bbac386b3cc475e0deebeb1175137e2969c61101ab98c5dd3e6cd8"
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
