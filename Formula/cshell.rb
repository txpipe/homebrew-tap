class Cshell < Formula
  desc "A Cardano wallet CLI built for developers."
  homepage "https://docs.txpipe.io/cshell"
  version "0.13.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/txpipe/cshell/releases/download/v0.13.0/cshell-aarch64-apple-darwin.tar.gz"
    sha256 "37bed256fdb16485d2b6d8ea53ecfbc1f56b83aad183eafd18889061dbf034e7"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.13.0/cshell-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d6cfb59d9b56aeeb54a644b34bd188d8ce00f5131f1ac8c5c8a240cc02f46320"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.13.0/cshell-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "184c8872e4546c63ac6c06a1d48d2a750ab274a97a6e4a14b6612bbf56b087aa"
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
    bin.install "cshell" if OS.mac? && Hardware::CPU.arm?
    bin.install "cshell" if OS.linux? && Hardware::CPU.arm?
    bin.install "cshell" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
