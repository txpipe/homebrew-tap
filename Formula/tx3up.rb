class Tx3up < Formula
  desc "Installer for the tx3 toolchain"
  homepage "https://github.com/tx3-lang/up"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tx3-lang/up/releases/download/v0.5.0/tx3up-aarch64-apple-darwin.tar.xz"
      sha256 "2acfabf8fbf12a46f944ffe1200a4a247ff6d970c16835333af1ac6aae7b1ee6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tx3-lang/up/releases/download/v0.5.0/tx3up-x86_64-apple-darwin.tar.xz"
      sha256 "315963b7e928d0fb7f601c47571def9e0967ae048e29dd07530f0957ea8aa120"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tx3-lang/up/releases/download/v0.5.0/tx3up-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61b55a2824a44c0bc02b23677334a0071538b06f7a1f076ac1f0bb6b58b9a458"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tx3-lang/up/releases/download/v0.5.0/tx3up-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a345b20b3bb9e26de180129950a3a43db2d6190a34244c24ae1c9930b8fac10"
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
