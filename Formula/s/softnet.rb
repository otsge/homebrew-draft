# typed: false
# frozen_string_literal: true

class Softnet < Formula
  desc "Software networking with isolation for Tart"
  homepage "https://github.com/openai/softnet"
  url "https://github.com/openai/softnet/releases/download/0.20.1/softnet.tar.gz"
  sha256 "4a94100aac9bc83b5527af923217ab615321a5322425484c4342947a6ae00214"
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
