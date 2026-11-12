class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.20.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.20.0/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "6a9336750e3450d6d01a812468087350e236ac0cd427f12d324ca7ca1abce5d8"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.20.0/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "6a9336750e3450d6d01a812468087350e236ac0cd427f12d324ca7ca1abce5d8"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.20.0/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "a7873955e694a0576a6b069f74013068cf41befee656646e76a4c2a8bb4720b0"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.20.0/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "a7873955e694a0576a6b069f74013068cf41befee656646e76a4c2a8bb4720b0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.20.0/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9d8b69251f8361916d27b27c694ecdb5336865c1e6cb6ef107334b8b5e66b22c"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.20.0/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9d8b69251f8361916d27b27c694ecdb5336865c1e6cb6ef107334b8b5e66b22c"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.20.0/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5417354c2faab32e377be178382d28e2e327ecce85858e3e05e905657986c9b9"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.20.0/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5417354c2faab32e377be178382d28e2e327ecce85858e3e05e905657986c9b9"
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
