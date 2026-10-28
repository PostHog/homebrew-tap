class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.19.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.19.0/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "2254c197b7c8f1dd793a05208b4eb1c6d58a3fa95864649adfe3f5f3833e9257"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.0/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "2254c197b7c8f1dd793a05208b4eb1c6d58a3fa95864649adfe3f5f3833e9257"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.19.0/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "bb107689f4db99ee4fe0ee0c8e8397884673433dfb5144fcb884250047b8743a"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.0/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "bb107689f4db99ee4fe0ee0c8e8397884673433dfb5144fcb884250047b8743a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.19.0/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "13a986a164b3ec8f093ef7f2a9cd1360ba2f9748deab1e8e4a471fbec85bb46c"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.0/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "13a986a164b3ec8f093ef7f2a9cd1360ba2f9748deab1e8e4a471fbec85bb46c"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.19.0/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6d753ad8eafef0c2a4cf3d64d59dca7ad8236688a812f58c4496cc482016d6b3"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.0/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6d753ad8eafef0c2a4cf3d64d59dca7ad8236688a812f58c4496cc482016d6b3"
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
