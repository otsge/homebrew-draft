# typed: false
# frozen_string_literal: true

class TartGuestAgent < Formula
  desc "Guest agent for Tart VMs"
  homepage "https://github.com/openai/tart-guest-agent"
  license "FSL-1.1-ALv2"

  if OS.mac?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.15.0/tart-guest-agent-darwin-all.tar.gz"
    sha256 "eb47f402f18e742a8ea96344115ca776179f9c4c67494bc0c46a10a68db280b7"
  end

  if OS.linux? && Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.15.0/tart-guest-agent-linux-amd64.tar.gz"
    sha256 "11ebdc760a185528235b8a745aa174ce030f6af9f712bbc911f3e925fe650841"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.15.0/tart-guest-agent-linux-arm64.tar.gz"
    sha256 "ec9d6111137f8a1e3c51b0df91fa7aaab9bb1af5fa155a370a8fc17f03c624e3"
  end

  def install
    bin.install "tart-guest-agent"
  end

  test do
    system bin/"tart-guest-agent", "--version"
  end
end
