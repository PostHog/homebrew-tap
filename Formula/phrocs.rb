# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
class Phrocs < Formula
  desc "PostHog development process runner"
  homepage "https://github.com/PostHog/posthog/tree/master/tools/phrocs"
  version "1.0.9"

  on_macos do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.9/phrocs-darwin-amd64"
      sha256 "bdac26f756cc5e5dde15a34430273be11f6d6254f5eaa77275e3ad486e48bd28"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.9/phrocs-darwin-arm64"
      sha256 "970783bdfda73a96698e60b59c0402bd38377bff803e0400bf2c6a063820c674"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.9/phrocs-linux-amd64"
      sha256 "c82c002b12626ff5d23ddba76c3db21b32e23f4bd4e7f11c168fd73ece9c5c0e"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.9/phrocs-linux-arm64"
      sha256 "c4451674a5ed5ffbc455ccc191752c69ad5eec25d550b67c9ba751900a781cc4"
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
