# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
class Phrocs < Formula
  desc "PostHog development process runner"
  homepage "https://github.com/PostHog/posthog/tree/master/tools/phrocs"
  version "1.0.5"

  on_macos do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.5/phrocs-darwin-amd64"
      sha256 "a1201373d233c13cbfb5802900802e9371117103c9a5fa1b9e62bdff1db0336c"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.5/phrocs-darwin-arm64"
      sha256 "24544543c1307aab65beadf336420cbba0e5103b34ed50e44c949ad593bdd948"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.5/phrocs-linux-amd64"
      sha256 "1f9a98e6a02f2bc15f6204381e54fbe5ec106e25b09313af4dc01ce674becfaf"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.5/phrocs-linux-arm64"
      sha256 "b15bc7dad5ad58f57e1591d7fd29cbbfb35126c2f367451a3d4d66c240b9b0c6"
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
