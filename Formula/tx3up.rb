class Tx3up < Formula
  desc "Installer for the tx3 toolchain"
  homepage "https://github.com/tx3-lang/up"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tx3-lang/up/releases/download/v0.6.1/tx3up-aarch64-apple-darwin.tar.xz"
      sha256 "83155a80c23e202b1c51090394252f6c327f4d458726935088aad6a61d5b4685"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tx3-lang/up/releases/download/v0.6.1/tx3up-x86_64-apple-darwin.tar.xz"
      sha256 "6cb8845453d3581f15e3f4e3aa389a79b8243b9911821ec475ea1dc46564186b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tx3-lang/up/releases/download/v0.6.1/tx3up-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cb4e1de64ef5fdc858c44b706dbde6f13a5b2a758e40e752827ba00e65936bd6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tx3-lang/up/releases/download/v0.6.1/tx3up-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ad0b00d42c89e6c29fef2c67adb8f4a152e3e301851194f6067dfc7948eb6cb1"
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
    bin.install "tx3up" if OS.mac? && Hardware::CPU.arm?
    bin.install "tx3up" if OS.mac? && Hardware::CPU.intel?
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
