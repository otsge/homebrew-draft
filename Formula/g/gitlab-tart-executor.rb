# typed: false
# frozen_string_literal: true

class GitlabTartExecutor < Formula
  desc "GitLab Runner Executor to run jobs inside isolated Tart VMs"
  homepage "https://github.com/cirruslabs/gitlab-tart-executor"
  url "https://github.com/cirruslabs/gitlab-tart-executor/releases/download/#{version}/gitlab-tart-executor-darwin-arm64.tar.gz"
  version "1.28.0"
  sha256 "5b7dea840cdbabcbf3806da1d95d58c3b125dc6385b9eace86fb746c52796103"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on :macos
  depends_on "otsge/draft/tart"

  def install
    bin.install "gitlab-tart-executor"
  end

  def caveats
    <<~EOS
      See the Github repository for more information
    EOS
  end

  test do
    system bin/"gitlab-tart-executor", "--version"
  end
end
