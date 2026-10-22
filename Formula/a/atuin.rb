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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "503b5a94731b454baee10a46abe8d2a547127a675b3e58aade17cf4481790087"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "24812a75400e9102fcd03d8fe0c57822b452e83fc4bd7e1b26cde553baa982b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ca6c56ba5b36daa5a91920404fd45e81ec4afcb560ac3c6b57bd629703988ff4"
    sha256 cellar: :any,                 arm64_linux:       "7913e8d289a7b0303e220789ea92913470f50010501c5e1d1534b3a5c9bf6573"
    sha256 cellar: :any,                 x86_64_linux:      "bc33d7c2df94669cbb744ebf384f05782246fb811b0b4b285e1bd23faeaac2d8"
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
