class Cshell < Formula
  desc "A Cardano wallet CLI built for developers."
  homepage "https://docs.txpipe.io/cshell"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.7.2/cshell-aarch64-apple-darwin.tar.gz"
      sha256 "77dd16d705791847153d2efc8ba6d0cd231c3973f52067f9ad58322cd4873525"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.7.2/cshell-x86_64-apple-darwin.tar.gz"
      sha256 "46a7e4a32d66cda562371e3f502db46e42795ec716eb23826bfb4d279dee7a14"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.7.2/cshell-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bb8f1b319ed40e03a289771cea0c2c37dbd3e8e5728762e1a3d2e2366904b939"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.7.2/cshell-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "add100117826253becd81c0dbeaac68bd47aea8d0161a03f95a79627410e0d08"
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
