class Vallum < Formula
  desc "Security boundary between AI coding agents and your shell — redacts secrets, neutralizes prompt injection, sanitizes untrusted terminal output, audits every command."
  homepage "https://github.com/kahramanemir/Vallum"
  version "0.8.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.9/vallum-aarch64-apple-darwin.tar.xz"
      sha256 "c5464e849ebd8539531ef9042152f7783aa01ee1dcce4014076019a0ec96291a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.9/vallum-x86_64-apple-darwin.tar.xz"
      sha256 "1a17234bc2eca50bc1d67b7edfb120513c147219a049d9db9af34e09d1a38179"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.9/vallum-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d016aa69d9db8dc4cf11ed63260db4fafe295d3ea5e15841f965336170286dd3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.9/vallum-x86_64-unknown-linux-musl.tar.xz"
      sha256 "fd4eb6f6d378e9f3594a38a20c67b126139ca64253d720e680f5c724a9d4fd45"
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
