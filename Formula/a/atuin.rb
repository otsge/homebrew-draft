class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  license "MIT"

  stable do
    url "https://github.com/atuinsh/atuin/releases/download/v18.23.0/source.tar.gz"
    sha256 "64b4b9b0f84ef34bcfa88e992d38cc0b95d3cf1f6d470bb695d3ef0231445b26"

    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles-v18.23.0.patch"
      sha256 "297029f2bee225e887e2456d492a421c4a2b7f7e96b1f20ac7892971b0424fd8"
      type :unofficial
    end
  end

  head do
    url "https://github.com/atuinsh/atuin.git", branch: "main"

    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles.patch"
      sha256 "5888e3f4c649997d2eaba90258ef2f0a7cf9537a1c14ad65cd7022e976ea3f4f"
      type :unofficial
    end
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  # Readd dotfile feature

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
