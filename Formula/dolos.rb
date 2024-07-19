class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "0.13.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.13.1/dolos-aarch64-apple-darwin.tar.xz"
      sha256 "d8b6650a9e437d4c730bb4f5dd9e51cd2d39ac7a49c7db45c0395b6fcf4b144c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.13.1/dolos-x86_64-apple-darwin.tar.xz"
      sha256 "813ddc2893a77496d4a77b17eec6ed70d09d17aef1611dd2ac661cee4bbf4823"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.13.1/dolos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "57014b6abee9a3eecbdc9d751bcde1bf5a245ba1e66868aae90916bb8e3ec25c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.13.1/dolos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cda0e20e7d56b28fdfa472dac79fe4c6e28cde3c1c18d4d89ec2ccbb6b24df58"
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
