# typed: false
# frozen_string_literal: true

class Softnet < Formula
  desc "Software networking with isolation for Tart"
  homepage "https://github.com/openai/softnet"
  url "https://github.com/openai/softnet/releases/download/0.25.0/softnet.tar.gz"
  sha256 "5a2e8ef779f0a2169b88d273ee806c0d64321ec7714c0dc99bf217523ae9b008"
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
