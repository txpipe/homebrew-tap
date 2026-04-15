class Tx3up < Formula
  desc "Installer for the tx3 toolchain"
  homepage "https://github.com/tx3-lang/up"
  version "0.8.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tx3-lang/up/releases/download/v0.8.0/tx3up-aarch64-apple-darwin.tar.xz"
    sha256 "48352b2ded8aefbfd0cbd02263d403726846bae982afbc78846c4ea22827122c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tx3-lang/up/releases/download/v0.8.0/tx3up-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "91b1aab3635df294a5e23c7d4dce1196eaaf6824e5cd987e3e2b9bbaeff4b92f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tx3-lang/up/releases/download/v0.8.0/tx3up-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "14b592cc65e7238b2f0b14f1a01afd83a5f5d73cd31d3aca26b7da0cbfbf0644"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "tx3up" if OS.mac? && Hardware::CPU.arm?
    bin.install "tx3up" if OS.linux? && Hardware::CPU.arm?
    bin.install "tx3up" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
