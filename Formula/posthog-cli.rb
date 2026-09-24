class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.18.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.6/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "0ba81ddfe1f0fd7df308f5e3667d1fbae7f0661842176875124edc2ff13a3392"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.6/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "0ba81ddfe1f0fd7df308f5e3667d1fbae7f0661842176875124edc2ff13a3392"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.6/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "501e83c07778ddc85b6ae2db5bf082cb25341382bc79c6ace635510b660d10ef"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.6/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "501e83c07778ddc85b6ae2db5bf082cb25341382bc79c6ace635510b660d10ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.6/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e66dcd85a9e44cebb661b17cb061aa2b3e188dd7da1b8e254eedbf6d46002f1c"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.6/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e66dcd85a9e44cebb661b17cb061aa2b3e188dd7da1b8e254eedbf6d46002f1c"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.6/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bfe223abd7d53c0393935a8c5282d6ebf4100c1ff4796859c25d215a4858e909"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.6/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bfe223abd7d53c0393935a8c5282d6ebf4100c1ff4796859c25d215a4858e909"
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
