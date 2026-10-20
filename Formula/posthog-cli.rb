class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.18.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.11/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "3bb0027df790dd2b497c440c991f1fce2c2aea5767f2739618bc8e00d83cf4ab"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.11/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "3bb0027df790dd2b497c440c991f1fce2c2aea5767f2739618bc8e00d83cf4ab"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.11/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "d274259851629b54777bb83a8f05e04ec96e657eb5387eb0b6fd6b7d629fa2ec"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.11/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "d274259851629b54777bb83a8f05e04ec96e657eb5387eb0b6fd6b7d629fa2ec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.11/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fb01e39b33a8f541c1f41429e3fb6c222cd8c4935d3f502aaa6e08dbf51c7e35"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.11/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fb01e39b33a8f541c1f41429e3fb6c222cd8c4935d3f502aaa6e08dbf51c7e35"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.11/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a46e6f78f04587399f789f7e5d077552c5f5a247b6fad92b1266116c7f824f88"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.11/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a46e6f78f04587399f789f7e5d077552c5f5a247b6fad92b1266116c7f824f88"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "posthog-cli"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "posthog-cli"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "posthog-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "posthog-cli"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
