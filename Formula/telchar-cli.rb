class TelcharCli < Formula
  desc "A toolchain that improves the developer experience of integrating Plutus validators in off-chain processes"
  homepage "https://registry.telchar.txpipe.io"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/telchar/releases/download/v0.1.0/telchar-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b14a00bab9ed7783b430b70286d4a0988b95337ce928acfb77d2305d21a64a2e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/telchar/releases/download/v0.1.0/telchar-cli-x86_64-apple-darwin.tar.xz"
      sha256 "16881180d39b78e41a019cc33387621796ea1ab8a831e5bdec7793e2f4f76eaa"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/txpipe/telchar/releases/download/v0.1.0/telchar-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "becfd0c7027282482923096a840ef4cbc9e8a6711352f11886505d17d39004e4"
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
    bin.install "telchar-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "telchar-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "telchar-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
