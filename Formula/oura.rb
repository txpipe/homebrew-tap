class Oura < Formula
  desc "The tail of Cardano"
  homepage "https://github.com/txpipe/oura"
  version "2.0.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/txpipe/oura/releases/download/v2.0.1/oura-aarch64-apple-darwin.tar.xz"
    sha256 "3835d312ff4094263dd14b04314f80a9fd2bb7d69b4e0bb8a995c2464206c99a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/oura/releases/download/v2.0.1/oura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "52ae9c937a1adb91e88093343df239e59b2c58dd687f1edd614bd3c23720b53a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/oura/releases/download/v2.0.1/oura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80ba8c0fb1a0619d999aa5d3239e0166a1a0792f663afe4cd6d5024d11d3c332"
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
