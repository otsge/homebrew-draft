class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  license "MIT"

  stable do
    url "https://github.com/atuinsh/atuin/releases/download/v18.24.4/source.tar.gz"
    sha256 "4106e8841321b8702497b2e84075706b7b14ddcf9401d4e638b338dc555e1fce"

    # Readd dotfile feature
    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles-v18.24.3.patch"
      sha256 "3c2ecaba10e0775bb51b9c4294dc320d48f15ae20a87b2200a91db6de64e5635"
      type :unofficial
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "890cfb30f8a9536a5f6a7ee9decdf571cbd6ab54be170ae1901ad5ac393ddd69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "acc51ae8b397dc568d917dcbfb4985c7130aeb4066150163d4fbbda097a8d6ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29b95883e0aa1a700e56f9ee1ffcc26e7019fefaac4471b91d0d6b32408971ba"
    sha256 cellar: :any,                 arm64_linux:       "f2e39646a838bca8b159ad719af6f56bca016c055be56c688da8978af0bfdedd"
    sha256 cellar: :any,                 x86_64_linux:      "661ff5b41ce353ee36e74a6e7f6833da528bc0627906c9cad3679875fb0936c0"
  end

  head do
    url "https://github.com/atuinsh/atuin.git", branch: "main"

    # Readd dotfile feature
    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles.patch"
      sha256 "db84a658128833033be795c2de1b2cabe81d168461809adb7cf134066e3c4862"
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
