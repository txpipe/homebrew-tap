class Telchar < Formula
  desc "A toolchain that improves the developer experience of integrating Plutus validators in off-chain processes"
  homepage "https://registry.telchar.txpipe.io"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/telchar/releases/download/v0.1.0/telchar-aarch64-apple-darwin.tar.xz"
      sha256 "29525723fc7c3f31d3a85af5116748f2962f881238907f6653b87c623f827ebf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/telchar/releases/download/v0.1.0/telchar-x86_64-apple-darwin.tar.xz"
      sha256 "ad7074f181ce5b8c6103c30efd45e102253d1fd869d0c361c11a707a4d8e28d0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/txpipe/telchar/releases/download/v0.1.0/telchar-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c06164e9815667f1ba2729810509189521ecebb301f45e40097cb2f01f31a048"
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
