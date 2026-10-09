# typed: false
# frozen_string_literal: true

class Softnet < Formula
  desc "Software networking with isolation for Tart"
  homepage "https://github.com/openai/softnet"
  url "https://github.com/openai/softnet/releases/download/0.24.1/softnet.tar.gz"
  sha256 "8ff8ff099c2b5ac1b1128e7999c4a730ac85f486c8a4cb0239eb98432859a0f7"
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
