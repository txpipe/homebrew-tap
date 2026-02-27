class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "1.0.0-rc.11"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0-rc.11/dolos-aarch64-apple-darwin.tar.gz"
      sha256 "1fd4953d84fb60c52476597e4819f3206581f5efd3ac976ec6bd4a181cd028fd"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0-rc.11/dolos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6e95c5738f1df61391209dfe12cdc81a46dd679d5ddc766924fc7869a5245940"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v1.0.0-rc.11/dolos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3e76c7806b209a2da1efae635ba09330a6d01b940c926fd46222e8ee62140410"
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
