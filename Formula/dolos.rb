class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "1.5.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/txpipe/dolos/releases/download/v1.5.0/dolos-aarch64-apple-darwin.tar.gz"
    sha256 "2f3827d3fba161ff19ea9a976a288f4369c9281df623af1ea85171141b1369af"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v1.5.0/dolos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7eec05594c75ae4754969a39da7342768565ba10679b8fb11fb1db5463c62085"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v1.5.0/dolos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fcebdaea5e5811b80861d73d3763df7c8afeed9c80c44e8c34bdb9f1fdda133e"
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
