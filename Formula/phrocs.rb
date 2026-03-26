# typed: false
# frozen_string_literal: true

# This file is auto-updated by CI on semver releases. DO NOT EDIT.
class Phrocs < Formula
  desc "PostHog development process runner"
  homepage "https://github.com/PostHog/posthog/tree/master/tools/phrocs"
  version "1.0.4"

  on_macos do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.4/phrocs-darwin-amd64"
      sha256 "f22f4635ae9a9417748556a8ea3ecb46df4925c0747d28094fea22705bed2599"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.4/phrocs-darwin-arm64"
      sha256 "0623932976d760496fba8735f98854ce35423eed2e5de9ba598035f22fbec6e6"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.4/phrocs-linux-amd64"
      sha256 "5bbb287dc3dfe635fe25936a7b03899acf622b7af578b536d4b947b837ae8e83"
    end
    on_arm do
      url "https://github.com/PostHog/posthog/releases/download/phrocs-1.0.4/phrocs-linux-arm64"
      sha256 "aa88cba82a54c8125357ca5ca551aaa80c7fd906c0adb828f3d9e3d9836ecef9"
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
