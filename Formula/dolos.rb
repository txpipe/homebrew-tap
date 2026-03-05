class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "1.0.0-rc.12"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0-rc.12/dolos-aarch64-apple-darwin.tar.gz"
      sha256 "76a193493ac33eba0009e7d1ccd9723fa2c1b5dc9ee0f2da7acd46ad5f60c118"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0-rc.12/dolos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0236d9015430566b4428f38acab84818e26fc811a05917edd7b9af43c5b211c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0-rc.12/dolos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e36e55c97cb1a6da40c65b1f4fdd59fdf7385096977a1e47037b7e05bdd44c32"
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
