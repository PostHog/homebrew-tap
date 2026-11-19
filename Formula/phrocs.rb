# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
class Phrocs < Formula
  desc "PostHog development process runner"
  homepage "https://github.com/PostHog/posthog/tree/master/tools/phrocs"
  version "1.0.11"

  on_macos do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.11/phrocs-darwin-amd64"
      sha256 "379cf4b02be48bb32aacbb432e6bbc1703d7176d675f98a8873104934960c9d3"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.11/phrocs-darwin-arm64"
      sha256 "a896b5b99fa551adef20502f551e5b97ab7b9444361d725e3e08435945020add"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.11/phrocs-linux-amd64"
      sha256 "a04c3b91ed2d0112622831d5f583c76b17f47179c132a49e49adca10db0d26f9"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.11/phrocs-linux-arm64"
      sha256 "16d1987856af23285b867e82beab06e996e1b4c519ffd7396270213bd20f0e54"
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
