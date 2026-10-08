class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.18.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.10/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "ac3610273be3c7bfd31b0e7f81d8b35119543bf66b99f669d1ec50abbb36d0da"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.10/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "ac3610273be3c7bfd31b0e7f81d8b35119543bf66b99f669d1ec50abbb36d0da"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.10/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "31340b1936e36e93fbb6759a506f9cf2b55057bcdf5d18113d67f90d9ebe7e58"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.10/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "31340b1936e36e93fbb6759a506f9cf2b55057bcdf5d18113d67f90d9ebe7e58"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.10/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eb3d4135fdeac40d7fe8f5706830216d1220d3d20a600f0afa6a0621b6b437a8"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.10/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eb3d4135fdeac40d7fe8f5706830216d1220d3d20a600f0afa6a0621b6b437a8"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.10/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "29f2d4409f08205bab7d52f9cc919e964ea2c867ec568b3acdd9ee3eb4149c3d"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.10/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "29f2d4409f08205bab7d52f9cc919e964ea2c867ec568b3acdd9ee3eb4149c3d"
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
