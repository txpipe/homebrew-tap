class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "1.0.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0/dolos-aarch64-apple-darwin.tar.gz"
      sha256 "90a93261c03555f9e8d7bfd3a6be578c1da07bcca44695a62f16d987806a95f0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0/dolos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "70e8fbee0d856164e7ee2b9ad5f6a64ec9472edd4bb7376c1074160f252895ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0/dolos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f4bd61e4d96085c57dc63e7732eec93d905ea608168309d18ae07b34185f93d7"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

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
    bin.install "dolos" if OS.mac? && Hardware::CPU.arm?
    bin.install "dolos" if OS.linux? && Hardware::CPU.arm?
    bin.install "dolos" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
