class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.19.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.19.3/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "13caa692e068f59ca9dfb7bb983db99d487673c162eb30cd4ce2740d312239d3"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.3/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "13caa692e068f59ca9dfb7bb983db99d487673c162eb30cd4ce2740d312239d3"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.19.3/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "b6bc57db44a580d97f48ff1cb57f76189ad5fd0ca0b9fe141cc844c49ab99d73"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.3/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "b6bc57db44a580d97f48ff1cb57f76189ad5fd0ca0b9fe141cc844c49ab99d73"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.19.3/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4a51ee2536e0ecdca25834fce5e193d30e06a2adaae06683c2e41da70eb457ae"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.3/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4a51ee2536e0ecdca25834fce5e193d30e06a2adaae06683c2e41da70eb457ae"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.19.3/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5da2a2a2ab42ae0569cd77411897b303c50c0692470c7b02a1356a089dfc86a5"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.3/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5da2a2a2ab42ae0569cd77411897b303c50c0692470c7b02a1356a089dfc86a5"
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
