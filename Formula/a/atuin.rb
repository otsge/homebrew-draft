class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  license "MIT"

  stable do
    url "https://github.com/atuinsh/atuin/releases/download/v18.23.0/source.tar.gz"
    sha256 "64b4b9b0f84ef34bcfa88e992d38cc0b95d3cf1f6d470bb695d3ef0231445b26"

    # Readd dotfile feature
    patch do
      url "https://www.surge.box.ca/files/atuin-readd-dotfiles-v18.23.0.patch"
      sha256 "297029f2bee225e887e2456d492a421c4a2b7f7e96b1f20ac7892971b0424fd8"
      type :unofficial
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0754257822bc11a8928b8dbd4e688f921b4e37747506b5de20cb69a7d32d621f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7852eaa83ddf82d75082c74c2fe0934c1e3452b83f171b6f5d7b2bc67023fa18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b17f13bb2d9851aae5817bc10a6b50189ce283b9655a5356404fdc9de7b59c1b"
    sha256 cellar: :any,                 arm64_linux:       "fae63a1de8afb482a0c8b489de03b8404ad686cef05442d05636ff3bb2044db5"
    sha256 cellar: :any,                 x86_64_linux:      "c5802f6b0e7034ee58a475fb47cc4274ae86cd99558dbb739e16b7156b0efce4"
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
