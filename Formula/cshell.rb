class Cshell < Formula
  desc "A Cardano wallet CLI built for developers."
  homepage "https://github.com/txpipe/cshell"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.2.0/cshell-aarch64-apple-darwin.tar.gz"
      sha256 "bc1cb6489e080b60eef3c9c9f298e2492710302bbcc9a8aba45d4b452f37ada9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.2.0/cshell-x86_64-apple-darwin.tar.gz"
      sha256 "98395175bff56d535822708d11e1c1e0e2a3268c1079d4f74ef6d83096a01c77"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.2.0/cshell-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0d10d35bb0fc132fc372d4d3c04e3af68d4a3a5747c0a55d6d09dad76b29cbd0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.2.0/cshell-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f1e6b17ce88986cada8b84460063d35b1efe30d844ff025a28c54084d9e32160"
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
