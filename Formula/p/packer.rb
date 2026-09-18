class Packer < Formula
  desc "Tool for creating identical machine images"
  homepage "https://releases.hashicorp.com/packer/"
  version "1.16.1"
  license "MPL-2.0"

  livecheck do
    url :homepage
    regex(%r{href=["']/packer/(\d+(?:\.\d+)+)/["' >]}i)
  end

  if OS.mac? && Hardware::CPU.intel?
    url "https://releases.hashicorp.com/packer/1.16.1/packer_1.16.1_darwin_amd64.zip"
    sha256 "e3655fb154e718526c3bcaacf327e6247e55945d2fefd59f84f535750f7ef5c4"
  end

  if OS.mac? && Hardware::CPU.arm?
    url "https://releases.hashicorp.com/packer/1.16.1/packer_1.16.1_darwin_arm64.zip"
    sha256 "c45cb1f851971e8a340c4a36434273cf2c8ef0cc7f5b3ac65588a3539b1df424"
  end

  if OS.linux? && Hardware::CPU.intel?
    url "https://releases.hashicorp.com/packer/1.16.1/packer_1.16.1_linux_amd64.zip"
    sha256 "af38a9e93e4ed1b9ca68206ae969c64c300c82a3dde46a780dfa629f0867f651"
  end

  if OS.linux? && Hardware::CPU.arm? && !Hardware::CPU.is_64_bit?
    url "https://releases.hashicorp.com/packer/1.16.1/packer_1.16.1_linux_arm.zip"
    sha256 "dfb61912e59912f7d559a1f2b7bdf9fad702ae0a86226d87a8cee04a981a08b7"
  end

  if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    url "https://releases.hashicorp.com/packer/1.16.1/packer_1.16.1_linux_arm64.zip"
    sha256 "4784ac0b9228a61f3ecb3861dbf0bf9ebeab6ddb0f5a10466126b8daa5db0de5"
  end

  def install
    bin.install "packer"
  end

  test do
    system bin/"packer", "--version"
  end
end
