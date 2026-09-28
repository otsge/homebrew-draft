# typed: false
# frozen_string_literal: true

class Tart < Formula
  desc "Run macOS and Linux VMs on Apple Hardware"
  homepage "https://github.com/openai/tart"
  url "https://github.com/openai/tart/releases/download/2.40.0/tart.tar.gz"
  sha256 "be0e525ea0aa40e6f1c14f9374df255238d6c05c83e9f01e8d400d245cef7b0c"
  license "FSL-1.1-ALv2"

  depends_on :macos

  on_macos do
    depends_on macos: :ventura
  end

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"tart.app/Contents/MacOS/tart"
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
