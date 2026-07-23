class MistCli < Formula
  desc "Mac command-line tool that automatically downloads macOS Firmwares / Installers"
  homepage "https://github.com/ninxsoft/mist-cli"
  url "https://github.com/ninxsoft/mist-cli/releases/download/v2.3/mist-cli.2.3.pkg"
  sha256 "ad4200e342535e7744ed6db04226b28403fd44f4d031e255f1de8d532fc89a69"
  license "MIT"

  depends_on :macos

  def install
    system "pkgutil", "--expand-full", buildpath/"mist-cli.#{version}.pkg", buildpath/"contents"
    bin.install buildpath/"contents/Payload/usr/local/bin/mist"
    generate_completions_from_executable(bin/"mist", "--generate-completion-script")
  end

  test do
    assert_predicate bin/"mist", :executable?
  end
end
