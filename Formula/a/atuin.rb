class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  license "MIT"

  stable do
    url "https://github.com/atuinsh/atuin/releases/download/v18.24.4/source.tar.gz"
    sha256 "4106e8841321b8702497b2e84075706b7b14ddcf9401d4e638b338dc555e1fce"

    # Readd dotfile feature
    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles-stable.patch"
      sha256 "3c2ecaba10e0775bb51b9c4294dc320d48f15ae20a87b2200a91db6de64e5635"
      type :unofficial
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8967be1184c068de495847073178c6de4bed9fa5f1b839fe10524d08c06fccc0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36544867c0744e5da9027243138c8795683782c0af2fe4bf88fa473854d61245"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e5a24c3ebe4d97fd9091aad864b8c826e3cff9670b62d43343e5e23c02050ac"
    sha256 cellar: :any,                 arm64_linux:       "527f59b013bf19fe000956fee055826d2d3c89a64dde9cf445eafde5247d2c72"
    sha256 cellar: :any,                 x86_64_linux:      "173f50db61c64734a223c31831cba1b34d25f93504e592d41ce54c614e5ca54e"
  end

  head do
    url "https://github.com/atuinsh/atuin.git", branch: "main"

    # Readd dotfile feature
    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles-head.patch"
      sha256 "3c2ecaba10e0775bb51b9c4294dc320d48f15ae20a87b2200a91db6de64e5635"
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
