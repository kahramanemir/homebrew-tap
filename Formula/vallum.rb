class Vallum < Formula
  desc "Security boundary between AI coding agents and your shell — redacts secrets, neutralizes prompt injection, sanitizes untrusted terminal output, audits every command."
  homepage "https://github.com/kahramanemir/Vallum"
  version "0.8.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.12/vallum-aarch64-apple-darwin.tar.xz"
      sha256 "2ebd20b0d6b7c3205308582b4bcf615a0d422ca2ab43aebd9baec76e55689f75"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.12/vallum-x86_64-apple-darwin.tar.xz"
      sha256 "f97485b3c74b742415fc4ed36fff99fe3a7221ba377c2567107df48727c5015e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.12/vallum-aarch64-unknown-linux-musl.tar.xz"
      sha256 "2f9592e9d9b54cac72e9b6c6d51cadc2034d9e5308c0184f04efac9aab02ff24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.12/vallum-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d44bf7a906b5a5c7132cf97ab66756fcf9e4b9a5d0b14074227c56b4e2485369"
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
