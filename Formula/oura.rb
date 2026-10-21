class Oura < Formula
  desc "The tail of Cardano"
  homepage "https://github.com/txpipe/oura"
  version "2.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/txpipe/oura/releases/download/v2.2.1/oura-aarch64-apple-darwin.tar.xz"
    sha256 "7419168c509f409e90f84d35ba932772d6e4f2a01f330d49abf2865ec7c47b60"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/oura/releases/download/v2.2.1/oura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6c18511f604ca1894663962cc658516cf9d2ce5819597419bd31888bcaa4ac67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/oura/releases/download/v2.2.1/oura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8ce5a84dcb1669b7c86d4858295d52b185ab99ed999477e123bb41e7a32fb78c"
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
      bin.install "oura"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "oura"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "oura"
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
