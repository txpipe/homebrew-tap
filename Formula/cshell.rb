class Cshell < Formula
  desc "A Cardano wallet CLI built for developers."
  homepage "https://docs.txpipe.io/cshell"
  version "0.13.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/txpipe/cshell/releases/download/v0.13.1/cshell-aarch64-apple-darwin.tar.gz"
    sha256 "d4e7b43bceec0d9d53e605c70cc7ddfc4d68a0566ebd7a116cc8370d74f4d0aa"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.13.1/cshell-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9fbacceb36a6f3147bd4f3c995f44aba2bb30bbb5342b52709e2710993afd5bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.13.1/cshell-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7973e40ecf248ecbe404b048f84d213606e0a2c7618142007378cb06a58b9e96"
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
