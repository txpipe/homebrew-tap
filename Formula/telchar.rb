class Telchar < Formula
  desc "A toolchain that improves the developer experience of integrating Plutus validators in off-chain processes"
  homepage "https://registry.telchar.txpipe.io"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/telchar/releases/download/v0.1.2/telchar-aarch64-apple-darwin.tar.xz"
      sha256 "ce886446f2173407a6c310707e29d45ec86b85444dfafed71722a3edd76b6a04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/telchar/releases/download/v0.1.2/telchar-x86_64-apple-darwin.tar.xz"
      sha256 "45b3e052c4ca19872eaae380d2baf980bf77ac1f6a452d629fcced841dcbc1e8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/txpipe/telchar/releases/download/v0.1.2/telchar-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "80e3005f9c4a3c864881537715d719c39563ce364401a6050c1b57af9cedd7d0"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "aarch64-pc-windows-gnu":   {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "telchar" if OS.mac? && Hardware::CPU.arm?
    bin.install "telchar" if OS.mac? && Hardware::CPU.intel?
    bin.install "telchar" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
