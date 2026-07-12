class Vallum < Formula
  desc "Security boundary between AI coding agents and your shell — redacts secrets, neutralizes prompt injection, sanitizes untrusted terminal output, audits every command."
  homepage "https://github.com/kahramanemir/Vallum"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.3/vallum-aarch64-apple-darwin.tar.xz"
      sha256 "fbf9c03210f4ff81a9edbca5a89122b4108cc3f52eb63de6580834cbc89c065f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.3/vallum-x86_64-apple-darwin.tar.xz"
      sha256 "171435179e0c56af69d34f4a836f5763a29caeffed1684bb92e16ac7edf4e4a4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.3/vallum-aarch64-unknown-linux-musl.tar.xz"
      sha256 "062832828febaa5fddc489b1b66357804d3fa6357532ed5a8270f5e896b1f489"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.3/vallum-x86_64-unknown-linux-musl.tar.xz"
      sha256 "9fd1368e8754d670d24f910ba844fed77c2fd4490202a097a8abf90e68fd606b"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "vallum" if OS.mac? && Hardware::CPU.arm?
    bin.install "vallum" if OS.mac? && Hardware::CPU.intel?
    bin.install "vallum" if OS.linux? && Hardware::CPU.arm?
    bin.install "vallum" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
