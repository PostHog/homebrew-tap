class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.19.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.19.4/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "7af1385c95d6782cf11affb771b769bdd965bc7e5ce1d9ddcb283040435e540f"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.4/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "7af1385c95d6782cf11affb771b769bdd965bc7e5ce1d9ddcb283040435e540f"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.19.4/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "0669e161a4ad0515ab4d4da694b3b37a26b878389493eddcd4c7f1be0392e5f1"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.4/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "0669e161a4ad0515ab4d4da694b3b37a26b878389493eddcd4c7f1be0392e5f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.19.4/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2747f472e724bbda2e5393bd95aa9199beada6b17f18ec88d1edfbf73c2d11c4"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.4/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2747f472e724bbda2e5393bd95aa9199beada6b17f18ec88d1edfbf73c2d11c4"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.19.4/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1795f4ce06dcce7ae475bbf678b8edc965baf5d956e0362d9d31b245bcb147e3"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.4/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1795f4ce06dcce7ae475bbf678b8edc965baf5d956e0362d9d31b245bcb147e3"
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
