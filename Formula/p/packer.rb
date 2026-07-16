class Packer < Formula
  desc "Tool for creating identical machine images"
  homepage "https://releases.hashicorp.com/packer/"
  version "1.15.4"
  license "MPL-2.0"

  livecheck do
    url :homepage
    regex(%r{href=["']/packer/(\d+(?:\.\d+)+)/["' >]}i)
  end

  if OS.mac? && Hardware::CPU.intel?
    url "https://releases.hashicorp.com/packer/#{version}/packer_#{version}_darwin_amd64.zip"
    sha256 "b3be60b44dcb74e7962afe22cc10b89a09c74b626fcd52f49ecee32b07b99e71"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://releases.hashicorp.com/packer/#{version}/packer_#{version}_darwin_arm64.zip"
    sha256 "d95ba177dd2ebb84d7d155493b4188ec2a519d2c3b041528db5b63a6aff9da80"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://releases.hashicorp.com/packer/#{version}/packer_#{version}_linux_amd64.zip"
    sha256 "15f97a6a99645c7d5308c609973b5280837b38e112beac413ccbce80da927cf1"
  end

  if OS.linux? && Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
    url "https://releases.hashicorp.com/packer/#{version}/packer_#{version}_linux_arm.zip"
    sha256 "b4830f7963fc34de7281e1d3a6e5dbb1d492334237f9247ec8dd2b13c552a409"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://releases.hashicorp.com/packer/#{version}/packer_#{version}_linux_arm64.zip"
    sha256 "23e6d2e596dd9e2527e0f7bea9aedd26059729375a0d17c462c2621f1b97b82d"
  end

  def install
    bin.install "packer"
  end

  test do
    system bin/"packer", "--version"
  end
end
