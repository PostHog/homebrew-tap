class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.20.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.20.1/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "6e40facbc2e26bac9b0333db3f7fc46330fb8707d28bbba04d2b49f6f9f66e50"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.20.1/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "6e40facbc2e26bac9b0333db3f7fc46330fb8707d28bbba04d2b49f6f9f66e50"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.20.1/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "7572dfe51c425e185069cca127f59980acb7082370ff5acce63bf3b84e425679"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.20.1/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "7572dfe51c425e185069cca127f59980acb7082370ff5acce63bf3b84e425679"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.20.1/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e4eb32f64deef2c7251a572ca3c3dae455a4d652305ab669df3bdc0ea2775338"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.20.1/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e4eb32f64deef2c7251a572ca3c3dae455a4d652305ab669df3bdc0ea2775338"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.20.1/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "42de1b77431fefc10653aada1f5a8023839090cd62d043b7746b273d2b75ca9d"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.20.1/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "42de1b77431fefc10653aada1f5a8023839090cd62d043b7746b273d2b75ca9d"
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
