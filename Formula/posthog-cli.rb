class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.19.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.19.2/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "39cd9bffef7f321edc6504c90c260d00e349849bd4d9e9bd735c7a4c38b0a38c"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.2/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "39cd9bffef7f321edc6504c90c260d00e349849bd4d9e9bd735c7a4c38b0a38c"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.19.2/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "d10f615e1cb773fbd1719803493394ff91a7dc870f3adfab1ebcc0ebea062452"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.2/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "d10f615e1cb773fbd1719803493394ff91a7dc870f3adfab1ebcc0ebea062452"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.19.2/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "686d713da3727cfe3872a23801efd62936172d03afc7db54676dec82617226f5"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.2/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "686d713da3727cfe3872a23801efd62936172d03afc7db54676dec82617226f5"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.19.2/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "546ca169c578fe019c470a8719f2c0f66a0d23b485cd9b47bfbae86ecc077afc"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.19.2/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "546ca169c578fe019c470a8719f2c0f66a0d23b485cd9b47bfbae86ecc077afc"
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
