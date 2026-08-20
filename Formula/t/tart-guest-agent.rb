# typed: false
# frozen_string_literal: true

class TartGuestAgent < Formula
  desc "Guest agent for Tart VMs"
  homepage "https://github.com/openai/tart-guest-agent"
  license "FSL-1.1-ALv2"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  if OS.mac?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.14.0/tart-guest-agent-darwin-all.tar.gz"
    sha256 "20ff5c88c9993df3d92664cd5e0eb57289c0ff06bc57171db8a14faa52596f6f"
  end

  if OS.linux? && Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.14.0/tart-guest-agent-linux-amd64.tar.gz"
    sha256 "58b59cdc5aa315d0b60f7f7f6e89749d718fe6e2a07cabc0d738fad8238ebd2e"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.14.0/tart-guest-agent-linux-arm64.tar.gz"
    sha256 "64248f18db2cd5e5aa3a4a5eaa7a6959c11a121c3b7f9911d2ee159f537ffe03"
  end

  def install
    bin.install "tart-guest-agent"
  end

  test do
    system bin/"tart-guest-agent", "--version"
  end
end
