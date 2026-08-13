class LibtorrentRasterbarAT20 < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent.git",
      tag:      "v2.0.14",
      revision: "aab2a10e2f60d9eac78e885a696736d043527794"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_1"

  livecheck do
    url :stable
    regex(/^v?(2\.0(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    sha256 cellar: :any, arm64_tahoe:   "125ad5647422f5e9f92964ded674422fdca6e4dedea7ad043ad0c31fe8db8bbf"
    sha256 cellar: :any, arm64_sequoia: "0c1af75d09eba1b5ae4af83a72b4de929ace1740b05a100fb472de150378eb77"
    sha256 cellar: :any, arm64_sonoma:  "8e37430463ccce51cd18352af6823c6be2dad8bd9701585618df098ea9348f73"
    sha256 cellar: :any, tahoe:         "ad215619e2e917ac2ebd1f411d0909a4cc5b6e523f702a7591a123e712b00fd3"
    sha256 cellar: :any, sequoia:       "417fefb870a4b9d345854d05a6d1d182c8e635bded9dbc9e737668d54d71a12f"
    sha256 cellar: :any, arm64_linux:   "84f41f1e29894d3eba8692319e239b13ebad341c8a0216cb09cc2544955e23af"
    sha256 cellar: :any, x86_64_linux:  "5f654741f8322f0c00b25eb718bcf67290654670e89519dc8f6944ebb4b53215"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.14"

  def install
    # Work around Homebrew's prefix scheme, which makes Python's reported
    # site-packages path absolute and outside the keg.
    site_packages = prefix/Language::Python.site_packages("python3.14")
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

    system "python3.14", "-c", "import libtorrent"
  end
end
