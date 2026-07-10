# typed: false
# frozen_string_literal: true

class Mtell < Formula
  desc "CLI to tell a machine to do something over VNC"
  homepage "https://github.com/cirruslabs/mtell"
  version "0.4.2"
  license "Apache-2.0"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on :macos

  if Hardware::CPU.intel?
    url "https://github.com/cirruslabs/mtell/releases/download/#{version}/mtell-darwin-amd64.tar.gz"
    sha256 "5b378c382285a9e7bdc9ac105b4e88a0c91067cfe57671979dd9c454aaaa61da"
  end

  if Hardware::CPU.arm?
    url "https://github.com/cirruslabs/mtell/releases/download/#{version}/mtell-darwin-arm64.tar.gz"
    sha256 "00bb54471369c23b75e8aa249b1f7c4c85edc2ae4eea8e01f2616f560e7aa01f"
  end

  def install
    bin.install "mtell"
    generate_completions_from_executable(bin/"mtell", "completion",
                                         shells: [:bash, :zsh, :fish, :pwsh])
  end

  def caveats
    <<~EOS
      See the Github repository for more information
    EOS
  end

  test do
    system bin/"mtell", "--version"
  end
end
