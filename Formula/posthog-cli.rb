class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.18.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.12/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "39f4bd1ea864d2335686a7097f85b5003983a906f934c925afe4443bc5384989"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.12/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "39f4bd1ea864d2335686a7097f85b5003983a906f934c925afe4443bc5384989"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.12/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "d0638d2a1acae1f9c6945291805606e4e207e879418bb7493199efa376da1f39"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.12/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "d0638d2a1acae1f9c6945291805606e4e207e879418bb7493199efa376da1f39"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.12/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ff5407411809d6754639e50b17b7aa52de323910e3e69f35b2fd159d6e7f2b17"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.12/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ff5407411809d6754639e50b17b7aa52de323910e3e69f35b2fd159d6e7f2b17"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.12/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "313458fd8caf7adec1d15e59b2a1abcc2e9ff52a00e54cad181ec052daa50b25"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.12/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "313458fd8caf7adec1d15e59b2a1abcc2e9ff52a00e54cad181ec052daa50b25"
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
