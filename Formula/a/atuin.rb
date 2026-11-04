class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  license "MIT"

  stable do
    url "https://github.com/atuinsh/atuin/releases/download/v18.24.5/source.tar.gz"
    sha256 "83f32a21916fb8d10d903a26fc0f3f5462367f81c18377b30efcbce7d8649c09"

    # Readd dotfile feature
    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles-stable.patch"
      sha256 "3c2ecaba10e0775bb51b9c4294dc320d48f15ae20a87b2200a91db6de64e5635"
      type :unofficial
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9902b003682f249513e18ff935a2d4b532834c4c068000f2c22afe3b36f3a04f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5ec7799ecac70547cd1754b4a93df4c4d050ec0c5f760b7d707174dd32fe4b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3bb5fd88d52035c850e8c1359f1436ae8d18682011973346f40175bf2cf4ce3d"
    sha256 cellar: :any,                 arm64_linux:       "8399a3b0a1c9dfd5c78bdba378c73560fc244da111e80143b4d88de10daf06ee"
    sha256 cellar: :any,                 x86_64_linux:      "8c9e48f8d52c0f85c29f6cadbca19eae89ce68c04905ba6e0e613bb2782b6279"
  end

  head do
    url "https://github.com/atuinsh/atuin.git", branch: "main"

    # Readd dotfile feature
    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles-head.patch"
      sha256 "0ec016229b1d6481ed96ea452bab9e060c9c4f92ac5eac3b3c236d0c9d7be92b"
      type :unofficial
    end
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run [opt_bin/"atuin", "daemon", "start"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
