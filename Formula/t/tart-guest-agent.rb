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
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.11.0/tart-guest-agent-darwin-all.tar.gz"
    sha256 "28e1b698c726c5f1d0f8c9d086b3390f6407d47e3f4b83081d9b2a9a2a1f0bc7"
  end

  if OS.linux? && Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.11.0/tart-guest-agent-linux-amd64.tar.gz"
    sha256 "0b2dab17ffa74a05f47837131cb7249cd0912ddaf5a20aa00a600b7e2d08dc01"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.11.0/tart-guest-agent-linux-arm64.tar.gz"
    sha256 "2b8d238dfb87445dfc66b8839ce72eb4c8193e034449291a69fa61f5b7753f96"
  end

  def install
    bin.install "tart-guest-agent"
  end

  test do
    system bin/"tart-guest-agent", "--version"
  end
end
