class Cshell < Formula
  desc "A Cardano wallet CLI built for developers."
  homepage "https://github.com/txpipe/cshell"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.1.0/cshell-aarch64-apple-darwin.tar.gz"
      sha256 "a2a3664a3d57e0592e2d06e1f29c9666d0697020b045529b3df67c9922ca33f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.1.0/cshell-x86_64-apple-darwin.tar.gz"
      sha256 "593551dbce019d0525da2f783777d111f81d93cff274f29503972609d99e7a2f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.1.0/cshell-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b1ece80b7e6ee1059f0de5edb76ea63d64f2cade3fdefc79e27a914bdfee9c12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.1.0/cshell-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7a3cbee2c1dff60a1bfd0b4a039176808c4db10a7afe6f70fd4944e5a0d94ace"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "aarch64-unknown-linux-gnu": {}, "x86_64-apple-darwin": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.mac? && Hardware::CPU.intel?
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
