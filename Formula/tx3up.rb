class Tx3up < Formula
  desc "Installer for the tx3 toolchain"
  homepage "https://github.com/tx3-lang/up"
  version "0.7.0"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/tx3-lang/up/releases/download/v0.7.0/tx3up-aarch64-apple-darwin.tar.xz"
      sha256 "648b76a97e19dc06cc48d71ff6edc22104a31a851c1ecbb7a4ce4c02e6ad5d8e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tx3-lang/up/releases/download/v0.7.0/tx3up-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7a3a8d473ba86ef14b1a6c1f2de15fecffe986baf30dd2bdbbba139cb6380eb6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tx3-lang/up/releases/download/v0.7.0/tx3up-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84bb2b43bbfca6e1661cb2f6ebbd27f8dad1e98eba0f8be93ec619ac9edeeb47"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "tx3up" if OS.mac? && Hardware::CPU.arm?
    bin.install "tx3up" if OS.linux? && Hardware::CPU.arm?
    bin.install "tx3up" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
