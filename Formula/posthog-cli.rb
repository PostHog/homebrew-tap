class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.18.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.5/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "d5d0c354e8fde1b613a44c45e5171614404b8261766a8c776ecae2b9d94169d8"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.5/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "d5d0c354e8fde1b613a44c45e5171614404b8261766a8c776ecae2b9d94169d8"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.5/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "3377d482b0e4d6d6bcf1e39cc0dfd7c7ec00eb88e371c45ac527cbe7ef5b68aa"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.5/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "3377d482b0e4d6d6bcf1e39cc0dfd7c7ec00eb88e371c45ac527cbe7ef5b68aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.5/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5b3f0147f6ff1a386d95fb90595144355d47dfce8b27cbcbc6b73a36c0815c33"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.5/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5b3f0147f6ff1a386d95fb90595144355d47dfce8b27cbcbc6b73a36c0815c33"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.5/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b641d40d9fe990d6f6e2481311952386c6693b93b847d42bf04f3d371b7d8a0c"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.5/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b641d40d9fe990d6f6e2481311952386c6693b93b847d42bf04f3d371b7d8a0c"
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
