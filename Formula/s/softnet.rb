# typed: false
# frozen_string_literal: true

class Softnet < Formula
  desc "Software networking with isolation for Tart"
  homepage "https://github.com/openai/softnet"
  url "https://github.com/openai/softnet/releases/download/0.26.0/softnet.tar.gz"
  sha256 "8469759f9cdfaaba52a150b629877985129308461702bc074c3ad7727837db82"
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
