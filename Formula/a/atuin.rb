class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  license "MIT"

  stable do
    url "https://github.com/atuinsh/atuin/releases/download/v18.24.8/source.tar.gz"
    sha256 "2dda9f81e1b42c4f7107aeb7dc8d957f55b43d4b104db73d05caa72a0a675c71"

    # Readd dotfile feature
    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles-stable.patch"
      sha256 "3c2ecaba10e0775bb51b9c4294dc320d48f15ae20a87b2200a91db6de64e5635"
      type :unofficial
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c804295bb4d9a5858abdd4355d207720aa4c9952b840e11a57ecde2c3a408f8a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ca7bb0a437ac54845d501cecb84892d64ca095d7816403ce2014d4c175dd790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf2b6484034a0afe0493590d5890f5fadc18c0d4590525a9becadcb5e2608c3e"
    sha256 cellar: :any,                 arm64_linux:       "2b1ac7bf3463c5a273425d60f5c4612eedff3f7ce830e4d49f1d5fe51fec32d4"
    sha256 cellar: :any,                 x86_64_linux:      "f5570d6245e8e4130c31acb2699099665ea5f7edfcb3e7d482e04e2982cd95e1"
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
