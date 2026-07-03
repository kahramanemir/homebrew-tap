class Vallum < Formula
  desc "Security boundary between AI coding agents and your shell — redacts secrets, neutralizes prompt injection, sanitizes untrusted terminal output, audits every command."
  homepage "https://github.com/kahramanemir/Vallum"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.4.0/vallum-aarch64-apple-darwin.tar.xz"
      sha256 "c5d0ebe3c0b0f03d534a6d24626b42c3ad2f3ea2d5aa2b65f2af2a498155ae26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.4.0/vallum-x86_64-apple-darwin.tar.xz"
      sha256 "01a399f480e3ca329d0dbd08110dcd01cf3f841a12e8664d3c20964591de2cd0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.4.0/vallum-aarch64-unknown-linux-musl.tar.xz"
      sha256 "38752c098e3775e754725073853e6b1d51810a4aa21b7a053f804a3d35893800"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.4.0/vallum-x86_64-unknown-linux-musl.tar.xz"
      sha256 "198c4ab4ead3ee211d9000d5ae997d70c04339b302ae1f7fe1d7337eb7cc350d"
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
