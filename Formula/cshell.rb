class Cshell < Formula
  desc "A Cardano wallet CLI built for developers."
  homepage "https://github.com/txpipe/cshell"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.2.1/cshell-aarch64-apple-darwin.tar.gz"
      sha256 "6e3ad7b645f5d6b98057b664a94224c929d27ed04b239fe4567db423311d275e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.2.1/cshell-x86_64-apple-darwin.tar.gz"
      sha256 "1479bd21d5fc803027eca362cecf3430d3df8570edcb56a189628fc2131e81be"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.2.1/cshell-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "189a0559d413c81399fc542a9da2cb614aa9f745bfef5bd157e8b457f45ee508"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.2.1/cshell-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "223f51d79e1e70f7422d0f0ad4ea0a280c2d6285e04d9c3757506db91f8341e7"
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
