class Cshell < Formula
  desc "A Cardano wallet CLI built for developers."
  homepage "https://docs.txpipe.io/cshell"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.6.0/cshell-aarch64-apple-darwin.tar.gz"
      sha256 "3daab4e5f0333a1173ee8cb8b2af50da11f64fc95874801efc24dfdedf4f86e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.6.0/cshell-x86_64-apple-darwin.tar.gz"
      sha256 "ad7de4d871f4f5f2f51792550da8c23ff6debae7253fbe277caacd2bcb957873"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.6.0/cshell-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dba2dedd523fc611ec8e8e704be4dae1483946b7d78069a63bd8ff7adc2e3fb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.6.0/cshell-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "01ceb9fc4fc105c10cf3f41b65bf1a9708a8cce21d8c3e4b8a112bbf9d352073"
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
    bin.install "cshell" if OS.mac? && Hardware::CPU.arm?
    bin.install "cshell" if OS.mac? && Hardware::CPU.intel?
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
