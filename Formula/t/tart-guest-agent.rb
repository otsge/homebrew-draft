# typed: false
# frozen_string_literal: true

class TartGuestAgent < Formula
  desc "Guest agent for Tart VMs"
  homepage "https://github.com/openai/tart-guest-agent"
  license "FSL-1.1-ALv2"

  livecheck do
    url :stable
    strategy :github_latest
  end

  if OS.mac?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.14.1/tart-guest-agent-darwin-all.tar.gz"
    sha256 "96596675452c8a4eed6f93c86a05b6a1e0c4bd2b0e381931b19ddeee3220eb23"
  end

  if OS.linux? && Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.14.1/tart-guest-agent-linux-amd64.tar.gz"
    sha256 "936682a1a8eb72f919bbfdba37117cc3787da41725e74bc20568bde91aae9bcd"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.14.1/tart-guest-agent-linux-arm64.tar.gz"
    sha256 "20ec76c449c38c16e9e79c0fe4d6d31b09e145eceed63973d074de86b3aa6539"
  end

  def install
    bin.install "tart-guest-agent"
  end

  test do
    system bin/"tart-guest-agent", "--version"
  end
end
