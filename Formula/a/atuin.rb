class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  license "MIT"

  stable do
    url "https://github.com/atuinsh/atuin/releases/download/v18.24.2/source.tar.gz"
    sha256 "1b52539da5d55962dc284fa10a78cf5dccc2961fd32af6812bf3d5969f632d9e"

    # Readd dotfile feature
    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles-v18.24.2.patch"
      sha256 "4c1f67a871c481b137f5ff0ee0e3eb0197a5c1ea456fbda5ca2ae961f81a75c0"
      type :unofficial
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d584fc326718b54908a9f791697871dbe58007fa6e42140ddb73ad67a3f45f1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e49df62d9836d390d01136ce302dfb1630b3aaabb73e5e3023082f2c635b6e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b867aaf4f806a62108dcceb863f6114f40705a35e0d794fa4225d65aa6bf3721"
    sha256 cellar: :any,                 arm64_linux:       "e6a9bb9591a255ae28151cc3e1f5c2ff3d7bc4892eebdeac13d1b4042ccf6060"
    sha256 cellar: :any,                 x86_64_linux:      "dd499fbec99845409af59ece15bb9cb2e3a41ca2ee68d4edb541e741a7345e05"
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
