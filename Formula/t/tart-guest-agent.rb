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
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.10.0/tart-guest-agent-darwin-all.tar.gz"
    sha256 "303a50d452753e36776ce8775e243be580bb3fc3ec8efde154320c37fd65b1a7"
  end

  if OS.linux? && Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.10.0/tart-guest-agent-linux-amd64.tar.gz"
    sha256 "007f82b8863bacdcaf291adeb01735f1f32b5f6390c8274def82479410f9f7da"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://github.com/openai/tart-guest-agent/releases/download/v0.10.0/tart-guest-agent-linux-arm64.tar.gz"
    sha256 "57478586a27f48920abaa00a131492caa237d0875948267cf2e61f05ad10bdb5"
  end

  def install
    bin.install "tart-guest-agent"
  end

  test do
    system bin/"tart-guest-agent", "--version"
  end
end
