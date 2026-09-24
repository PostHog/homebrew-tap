class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.18.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.7/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "2bbf2436d8db98831e930b632716d0112234a112dcdd10f3f7ada0fdda2adf38"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.7/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "2bbf2436d8db98831e930b632716d0112234a112dcdd10f3f7ada0fdda2adf38"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.7/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "c08def74f0276700ef330d703cca57f7dac4b801c957325e1ae40da091e2aa0b"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.7/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "c08def74f0276700ef330d703cca57f7dac4b801c957325e1ae40da091e2aa0b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.7/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b79422f3baba535e29f8e8d70dd4f566f084384dcc5c628da62938dffaadc431"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.7/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b79422f3baba535e29f8e8d70dd4f566f084384dcc5c628da62938dffaadc431"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.7/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e6b9f002346f1a29cb01f82a57cf39fcdb9569b8d33e5a29552e8274b800f501"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.7/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e6b9f002346f1a29cb01f82a57cf39fcdb9569b8d33e5a29552e8274b800f501"
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
