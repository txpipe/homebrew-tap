class Cshell < Formula
  desc "A Cardano wallet CLI built for developers."
  homepage "https://docs.txpipe.io/cshell"
  version "0.15.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/txpipe/cshell/releases/download/v0.15.1/cshell-aarch64-apple-darwin.tar.gz"
    sha256 "4c0cc80a52e5d8993f4770e7c557419a6bd5e99fc553103c0a9646174753600c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.15.1/cshell-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e64434ed16b92066daed22b2d08b23ac994e671f9a049adaea2b86ca71f47561"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.15.1/cshell-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "61b1ff0d2b799dfc2b0d8095f9c7703919c6f706d3e10c7a4147f3ecd4363938"
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
      bin.install "cshell"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cshell"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cshell"
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
