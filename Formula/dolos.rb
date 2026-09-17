class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "1.6.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/txpipe/dolos/releases/download/v1.6.1/dolos-aarch64-apple-darwin.tar.gz"
    sha256 "f792c63bd4fa26a8af8b68d6e23f47876c270ad638954b45317779b5683d2a58"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v1.6.1/dolos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f45b235f997778305015eac06896d176994c42de3e6e4ed13530594250cfcc86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v1.6.1/dolos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a06447051a0c6bc0fcfe8069d1828d90f199cc7072ed06a17442cd45b818f9d2"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dolos"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dolos"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dolos"
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
