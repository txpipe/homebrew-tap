class Oura < Formula
  desc "The tail of Cardano"
  homepage "https://github.com/txpipe/oura"
  version "2.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/txpipe/oura/releases/download/v2.2.0/oura-aarch64-apple-darwin.tar.xz"
    sha256 "414cca8fcd0a4c236bbd389b946271426178424b62fc645fb7e4b421caf29283"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/oura/releases/download/v2.2.0/oura-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49443d389ad7b3e44204f4ab48fc84365e7b4f765dc7c86511bbd0dd68decdaa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/oura/releases/download/v2.2.0/oura-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "06134eb1ea62bd999228d52787d6f512d2b485128144a4ed6290aad4d783b95f"
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
    bin.install "oura" if OS.mac? && Hardware::CPU.arm?
    bin.install "oura" if OS.linux? && Hardware::CPU.arm?
    bin.install "oura" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
