class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.19.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.19.1/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "e63b95cb1c746e6e3aeeed53b1418cb1b3db38851605725e71a067dceb0e7155"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.1/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "e63b95cb1c746e6e3aeeed53b1418cb1b3db38851605725e71a067dceb0e7155"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.19.1/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "c5029c09e88975c0733127ee7b9c1e310cd8ed692a91276c524862e3c92e4f81"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.1/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "c5029c09e88975c0733127ee7b9c1e310cd8ed692a91276c524862e3c92e4f81"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.19.1/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "803e9ce7e55e547b0e8e379355c0b68002b9631c75f6fd560e00c29fed67e37a"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.1/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "803e9ce7e55e547b0e8e379355c0b68002b9631c75f6fd560e00c29fed67e37a"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.19.1/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f352b5c609dd96947874e06f9dd5280c4bb61b8505a22ccb6e2018edc0e0f1f1"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.1/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f352b5c609dd96947874e06f9dd5280c4bb61b8505a22ccb6e2018edc0e0f1f1"
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
