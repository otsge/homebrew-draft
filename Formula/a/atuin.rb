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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d8b9b5d055bca62e2dbeb6e46add6103a8da314e4d3f28e5777ffe5c957fa373"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ab855891db5e3885f41e8758ea723b14f5ed5c587e736a1d3fd676571e09e7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "25fdb2f50da44b1d1fb1819e83e84acfb45f003ee618897e22e63045d83a0471"
    sha256 cellar: :any,                 arm64_linux:       "a334b62fe0a34d85614b93d1f2379b1e77e77788ce37805449bd09ccb8ccb961"
    sha256 cellar: :any,                 x86_64_linux:      "68785eb0f9b9dfc9493481c01da5a7d5ffe817d86d33de3bb7f1e457bc5fbb50"
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
