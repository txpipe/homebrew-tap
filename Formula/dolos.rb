class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "0.27.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.27.1/dolos-aarch64-apple-darwin.tar.gz"
      sha256 "798759abbaffff41160cb2bce70493b6c3ef6b8ea248df7a8ee4ad1188134244"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.27.1/dolos-x86_64-apple-darwin.tar.gz"
      sha256 "187d0199be48a83246d03e0f677b5fb228f55d94ea3259f77e81d4363e89aaa5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.27.1/dolos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1042b49d6dc6b17100cd886a4af6b2935442e7c6b86b36b09e6f0c0a3fc3b949"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.27.1/dolos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1d7ea3fb3ca8f80f5c2e2156d1640e2b361fe629d144a4fbb2d8b110d7c40155"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "dolos" if OS.mac? && Hardware::CPU.intel?
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
