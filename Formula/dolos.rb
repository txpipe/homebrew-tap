class Dolos < Formula
  desc "A Cardano data-node built in Rust"
  homepage "https://github.com/txpipe/dolos"
  version "0.29.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.29.0/dolos-aarch64-apple-darwin.tar.gz"
      sha256 "410a9b5419f90ecff02c9f19b733be558f3c9a4dc0bea2b00c5ae8fa6e0d6488"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.29.0/dolos-x86_64-apple-darwin.tar.gz"
      sha256 "f7442ac702cd4b4757da5befd5f44e7453f18cbfe4a5f152d4948fc23c6c8669"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/dolos/releases/download/v0.29.0/dolos-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f78598401c52f87ca49ce24394d98b157d612701a528281c88ff1f10785ae082"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/dolos/releases/download/v0.29.0/dolos-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4fea1886c2a94f392fc570a6a638e5aa4bb94d4fcbe2ee65fe586d8b7f35bc96"
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
