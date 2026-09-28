class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.18.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.9/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "831d3a8f16f95fc7cdbff7c9e83a32f012e8bd5af983646582f52e3ca4221d01"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.9/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "831d3a8f16f95fc7cdbff7c9e83a32f012e8bd5af983646582f52e3ca4221d01"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.9/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "8b8458f832eea96bd6b611927150467bae31256e63923a4e75a42cc7f22d7d8b"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.9/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "8b8458f832eea96bd6b611927150467bae31256e63923a4e75a42cc7f22d7d8b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.9/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7938a1a2bf68b8d9727ac8efca0cf1a1cd432b0b11afa3885db4e293aead9a30"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.9/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7938a1a2bf68b8d9727ac8efca0cf1a1cd432b0b11afa3885db4e293aead9a30"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.9/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6c5d85332d38feaf868ec3b27a4601843dc0ddbef394d3564f24288661ef37d4"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.9/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6c5d85332d38feaf868ec3b27a4601843dc0ddbef394d3564f24288661ef37d4"
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
