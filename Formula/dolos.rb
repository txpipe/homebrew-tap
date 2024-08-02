class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.14.0/dolos-aarch64-apple-darwin.tar.xz"
      sha256 "a12a953e4fd5b80686a0eab3d6ddb050a9ac936ebc6a55bd8f19896984531b02"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.14.0/dolos-x86_64-apple-darwin.tar.xz"
      sha256 "6758c26e34bb08def8284ece259a032868849e334de188dd7ed9b28acb21b3cd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.14.0/dolos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "195881d6c5c00271eb8fec188087b1d67011c92b676f4b61cc85a4e6ff0065b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.14.0/dolos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c66c40ad9923e52ed537fbfabc87c6f462ec866525a820b252fdf872113ea361"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "aarch64-unknown-linux-gnu": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.mac? && Hardware::CPU.intel?
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
