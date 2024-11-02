class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "0.18.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.18.2/dolos-aarch64-apple-darwin.tar.xz"
      sha256 "cb966b155199944efd86b956def965f2e7b08fc8605bce26c0dd6ba1f5ff411d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.18.2/dolos-x86_64-apple-darwin.tar.xz"
      sha256 "3d24f62b4d6fb5bec4fe35d679f4306fdbb8ce70ba43b62cf7b7420f59fc7076"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.18.2/dolos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e2fcaca886652c7496091fe24acc00328f6251356c340193c466823439d047de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.18.2/dolos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "10341584e52c8c517f81cfc5f946b7cfe6715a629f3d823b635a98e8230d724a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "aarch64-unknown-linux-gnu": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.linux? && Hardware::CPU.arm?
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
