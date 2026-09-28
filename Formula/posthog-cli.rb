class PosthogCli < Formula
  desc "The command line interface for PostHog 🦔"
  homepage "https://posthog.com"
  version "0.18.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.8/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "7f95f35b4502a77b408b3b33186af55c1e648200a329a113783f1f5670f69b78"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.8/posthog-cli-aarch64-apple-darwin.tar.gz"
      sha256 "7f95f35b4502a77b408b3b33186af55c1e648200a329a113783f1f5670f69b78"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.8/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "a50ba6f2d70785697901ef83f10aadbd78cbcc49bb01a5cf8a9812fcfdd2ee74"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.8/posthog-cli-x86_64-apple-darwin.tar.gz"
      sha256 "a50ba6f2d70785697901ef83f10aadbd78cbcc49bb01a5cf8a9812fcfdd2ee74"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://releases.posthog.com/posthog-cli/v0.18.8/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "660daefc3223253156d924cb5bd5240f0b074a1503e9d5f5131b95351503a586"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.8/posthog-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "660daefc3223253156d924cb5bd5240f0b074a1503e9d5f5131b95351503a586"
    end
    if Hardware::CPU.intel?
      url "https://releases.posthog.com/posthog-cli/v0.18.8/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "873aed94ebbc85ba90838932de9c9f0eee487235c58528bf707cdfe1f2df4b58"
      mirror "https://github.com/PostHog/posthog/releases/download/posthog-cli/v0.18.8/posthog-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "873aed94ebbc85ba90838932de9c9f0eee487235c58528bf707cdfe1f2df4b58"
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
