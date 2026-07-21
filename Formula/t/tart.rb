# typed: false
# frozen_string_literal: true

class Tart < Formula
  desc "Run macOS and Linux VMs on Apple Hardware"
  homepage "https://github.com/openai/tart"
  url "https://github.com/openai/tart/releases/download/2.33.1/tart.tar.gz"
  sha256 "ad7c3b340d605a332b4c7dc37ed6e4db495bf7a6f6f708b0924f51c8e2ecbe33"
  license "FSL-1.1-ALv2"

  depends_on :macos

  on_macos do
    depends_on macos: :ventura
  end

  def install
    libexec.install Dir["*"]
    bin.write_exec_script "#{libexec}/tart.app/Contents/MacOS/tart"
  end

  def post_install
    generate_completions_from_executable(libexec/"tart.app/Contents/MacOS/tart", "--generate-completion-script")
  end

  def caveats
    <<~EOS
      Tart has been installed. You might want to reduce the default DHCP lease time
      from 86,400 to 600 seconds to avoid DHCP shortage when running lots of VMs daily:

        sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.InternetSharing.default.plist bootpd -dict DHCPLeaseTimeSecs -int 600

      See https://tart.run/faq/#changing-the-default-dhcp-lease-time for more details.
    EOS
  end

  test do
    system bin/"tart", "--version"
  end
end
