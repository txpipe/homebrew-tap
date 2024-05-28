class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.9.0/dolos-aarch64-apple-darwin.tar.xz"
      sha256 "afe48c7c490f30c5a86976371c2f2a55bea329addc85ebe2dc06041deb8034a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.9.0/dolos-x86_64-apple-darwin.tar.xz"
      sha256 "668a1ad08d4e192bd322fc38e61674a5dc915f3524539b79a71f461279e3b3f7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.9.0/dolos-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b4720798061c5005f36b0914100272ad570203ceb94218ac27637104465ee9cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.9.0/dolos-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b6cb77bbfefb514f485e81def0e58b6645c5e9f10284097208df2b11a976bc0e"
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
