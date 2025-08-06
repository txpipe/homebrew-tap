class Tx3up < Formula
  desc "Installer for the tx3 toolchain"
  homepage "https://github.com/tx3-lang/up"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tx3-lang/up/releases/download/v0.6.0/tx3up-aarch64-apple-darwin.tar.xz"
      sha256 "3d587f83c9d0b3bbde3aeca15975a1c58f1aae342832bef6c86737be0499227b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tx3-lang/up/releases/download/v0.6.0/tx3up-x86_64-apple-darwin.tar.xz"
      sha256 "84c12ce8ed9d671bb3a1e042798e9830a33e4ae3b4f9b1ee9c1ba647347e4a5e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tx3-lang/up/releases/download/v0.6.0/tx3up-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "829200c9c3c0ee31ab457876c9db5fef47aaeed9d43c5d4fcb9d6535fd423a84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tx3-lang/up/releases/download/v0.6.0/tx3up-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4eb63ae430fe75bd24c4116d491507d3b423b33dccb6c852f2443806b3e6392d"
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
