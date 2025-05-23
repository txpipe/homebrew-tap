class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "0.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.23.0/dolos-aarch64-apple-darwin.tar.gz"
      sha256 "09e9a43c60dab83a92495ea307df197e747125e69f3c5c88f0ba3e19629646a9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.23.0/dolos-x86_64-apple-darwin.tar.gz"
      sha256 "a8b01be0c3750d48f4a448229e57f349550ce51346c9a1c81fdea3e624ed7b6d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.23.0/dolos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "817919051ad199fcf838d95ade00b9882a35e7682bd160cfce8d6d9df46cbf5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.23.0/dolos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bf41cf280c63e1351c02552a2fd3a314ea141d5852f2a97ad3ef4ae29ccae591"
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
    bin.install "dolos" if OS.mac? && Hardware::CPU.arm?
    bin.install "dolos" if OS.mac? && Hardware::CPU.intel?
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
