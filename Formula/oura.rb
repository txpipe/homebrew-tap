class Oura < Formula
  desc "The tail of Cardano"
  homepage "https://github.com/txpipe/oura"
  version "2.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/txpipe/oura/releases/download/v2.3.0/oura-aarch64-apple-darwin.tar.xz"
    sha256 "717b9af270f6ccfe0daed482cb110445e80dd4314aef093fd24d0eb6b4720bb5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/oura/releases/download/v2.3.0/oura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8f9cc05777f6d0328a1e204ac8674dfb4c16916b92be515fc85d65a09a8bfa0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/oura/releases/download/v2.3.0/oura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "926f2bc383b3ec2bff17d97aa82b6739d2ebc5d893025cf6a192604d3191537e"
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
