class LibtorrentRasterbarAT20 < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent.git",
      tag:      "v2.0.16",
      revision: "0a49da5d07a961b8f3e423a3a2ca83517ad8b37d"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_1"

  livecheck do
    url :stable
    regex(/^v?(2\.0(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    manifest_sha256 "31b7eede39a8f20e2c3e4b015fa106729596d45e12757fcb5654eb87974673ea"
    sha256 cellar: :any, arm64_golden_gate: "8bc9120fde312f8600a812d0f9b4cb9c2b2b8cb9034854f80f7f0c5c79e096fd"
    sha256 cellar: :any, arm64_tahoe:       "d646396ba6c23126c1dad1ad23fb385ee5f12a24183c16a7ac1fb97f0bb94bc4"
    sha256 cellar: :any, arm64_sequoia:     "cdc1a17d191f3086b4530347a9dc394e5c703bf3ee267ad006afd94a87c40292"
    sha256 cellar: :any, arm64_linux:       "d664a127410733c6ae2009a2e368d43f1c1a13d5ccfec79c0d688a010a289280"
    sha256 cellar: :any, x86_64_linux:      "8c3e9fb1c8d74f2cdc5ff8777923484eb02f95ea646d16d5e99f59e2b99d72ac"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@4"
  depends_on "python@3.15"

  deny_network_access!

  def install
    # Work around Homebrew's prefix scheme, which makes Python's reported
    # site-packages path absolute and outside the keg.
    site_packages = prefix/Language::Python.site_packages("python3")
    inreplace "bindings/python/CMakeLists.txt", "${_PYTHON3_SITE_ARCH}", site_packages

    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DNO_EXAMPLES=ON
      -DNO_TESTS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "examples"
  end

  test do
    args = [
      "-I#{Formula["boost"].include}/boost",
      "-L#{Formula["boost"].lib}",
      "-I#{include}",
      "-L#{lib}",
      "-lpthread",
      "-ltorrent-rasterbar",
    ]

    if OS.mac?
      args += [
        "-framework",
        "SystemConfiguration",
        "-framework",
        "CoreFoundation",
      ]
    end

    system ENV.cxx, libexec/"examples/make_torrent.cpp",
                    "-std=c++14", *args, "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_path_exists testpath/"test.torrent"

    system "python3.15", "-c", "import libtorrent"
  end
end
