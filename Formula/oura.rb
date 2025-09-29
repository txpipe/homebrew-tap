class Oura < Formula
  desc "The tail of Cardano"
  homepage "https://github.com/txpipe/oura"
  version "2.0.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/txpipe/oura/releases/download/v2.0.0/oura-aarch64-apple-darwin.tar.xz"
    sha256 "f879a21ac28b065006e17b63c1f16993f2d46b340b733c11acaa59acb2729070"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/oura/releases/download/v2.0.0/oura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d057b5e4cdd51f00a1fa40dfb0e0266954c2f1349a38640ad8ee724e4225e079"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/oura/releases/download/v2.0.0/oura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "724c2115696a453c65e6c12405412275c686e9a55913c56b58ee4c489412b2b5"
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
    bin.install "oura" if OS.mac? && Hardware::CPU.arm?
    bin.install "oura" if OS.linux? && Hardware::CPU.arm?
    bin.install "oura" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
