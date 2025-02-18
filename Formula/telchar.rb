class Telchar < Formula
  desc "A toolchain that improves the developer experience of integrating Plutus validators in off-chain processes"
  homepage "https://registry.telchar.txpipe.io"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/telchar/releases/download/v0.1.1/telchar-aarch64-apple-darwin.tar.xz"
      sha256 "c1aa1c1f2898ab9f81c87b6cf46c1f28a18b789cc14ab7fdfd583b4109520115"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/telchar/releases/download/v0.1.1/telchar-x86_64-apple-darwin.tar.xz"
      sha256 "de6c742885f454289c9fba97168b16681206796297ca830f057602fd73d1cce4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/txpipe/telchar/releases/download/v0.1.1/telchar-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "efa7855185c59f606679ee0187b33b5c49acc079a930af829eae3237b6ace1ea"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "aarch64-pc-windows-gnu":   {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "telchar" if OS.mac? && Hardware::CPU.arm?
    bin.install "telchar" if OS.mac? && Hardware::CPU.intel?
    bin.install "telchar" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
