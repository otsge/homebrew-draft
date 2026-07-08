# typed: false
# frozen_string_literal: true

class Softnet < Formula
  desc "Software networking with isolation for Tart"
  homepage "https://github.com/openai/softnet"
  url "https://github.com/openai/softnet/releases/download/0.20.0/softnet.tar.gz"
  sha256 "46f6d5056aaa3d445f56040283d60d9b91980634cb525d8bb6b687a83b62575c"
  license "FSL-1.1-ALv2"

  define_method(:install) do
    bin.install "softnet"
  end

  depends_on :macos

  def caveats
    <<~EOS
      See the Github repository for more information
    EOS
  end

  test do
    system bin/"softnet", "--help"
  end
end
