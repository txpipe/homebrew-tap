class Cshell < Formula
  desc "A Cardano wallet CLI built for developers."
  homepage "https://docs.txpipe.io/cshell"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.7.1/cshell-aarch64-apple-darwin.tar.gz"
      sha256 "93860bd92718044dc94d50b503e6681a5ff250d386de9e972ccc86767a1d2b85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.7.1/cshell-x86_64-apple-darwin.tar.gz"
      sha256 "6068e5bb74fec07afa8baf0901913acb4d609626be726a583189afa72f4bc3aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/txpipe/cshell/releases/download/v0.7.1/cshell-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d78df4d0ba93281693dda15a4d0c30b459aa713351d86ac524ed68c071aca808"
    end
    if Hardware::CPU.intel?
      url "https://github.com/txpipe/cshell/releases/download/v0.7.1/cshell-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "506edb7f6c7ad82b07859d6e024cadf703f2fdfa1b8f591c7df89478cacca044"
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
    bin.install "cshell" if OS.mac? && Hardware::CPU.arm?
    bin.install "cshell" if OS.mac? && Hardware::CPU.intel?
    bin.install "cshell" if OS.linux? && Hardware::CPU.arm?
    bin.install "cshell" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
