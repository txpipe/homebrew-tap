class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.8.0/dolos-aarch64-apple-darwin.tar.xz"
      sha256 "7153ee68f8071c42677ac09d6a54442307d21570f1f99fb188333cf58eba025e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.8.0/dolos-x86_64-apple-darwin.tar.xz"
      sha256 "f88e4a2bd0326dc10cb0041101fd89001db9051d77477f50a64cd690fc1b9744"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.8.0/dolos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb0131fad75f4994dbf3b41bf038cb695bed94bb093b13db56aab54fb8627b02"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "dolos"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dolos"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dolos"
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
