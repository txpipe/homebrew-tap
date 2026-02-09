class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "1.0.0-rc.9"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0-rc.9/dolos-aarch64-apple-darwin.tar.gz"
      sha256 "30b43a6e5f1cb8aa17e192afd0f7ddb4730013c8cd8eb0abcff2b104841176f6"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0-rc.9/dolos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0cbd6d8a7c6c5da92dc142c302d481a2ea7e8f450f2ef8f4546f671ff82155af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0-rc.9/dolos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b1d7b8f9fa04e686e42749b6e679883bbbafe4708668b6fb56ee2c2ec8f3cb11"
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
    bin.install "dolos" if OS.mac? && Hardware::CPU.arm?
    bin.install "dolos" if OS.linux? && Hardware::CPU.arm?
    bin.install "dolos" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
