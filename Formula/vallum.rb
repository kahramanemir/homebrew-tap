class Vallum < Formula
  desc "Security boundary between AI coding agents and your shell — redacts secrets, neutralizes prompt injection, sanitizes untrusted terminal output, audits every command."
  homepage "https://github.com/kahramanemir/Vallum"
  version "0.8.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.4/vallum-aarch64-apple-darwin.tar.xz"
      sha256 "9817ec0375d454a28486444b6a5381a75b23e1ceb741bb1d46f3d9e8f4824d61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.4/vallum-x86_64-apple-darwin.tar.xz"
      sha256 "66ac51351f5e84804d3636a3387ab35bc81f04b40ecb68cbaf485f4f5dd468a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.4/vallum-aarch64-unknown-linux-musl.tar.xz"
      sha256 "cca5d32c167126b4e707c846147bef50124d676eba1c86147b9b6f411c97a6f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kahramanemir/Vallum/releases/download/v0.8.4/vallum-x86_64-unknown-linux-musl.tar.xz"
      sha256 "bfed6ec6587700f14272f5f2f19b69c3edb608f68afad6ec1e10733a7ca3d5ba"
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
