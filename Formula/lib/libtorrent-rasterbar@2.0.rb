class LibtorrentRasterbarAT20 < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent.git",
      tag:      "v2.0.15",
      revision: "1eb18faeae156d8dbbab42935c082f8b81f50989"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_1"

  livecheck do
    url :stable
    regex(/^v?(2\.0(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "799e755e01b51ffc4437970c60611bf337d012b5340399e2d3decee2916cdc0e"
    sha256 cellar: :any, arm64_tahoe:       "9ba6d536d8cfa1a884b221cbab92a2ace5e17f4c8682b210ae48939eb3b47409"
    sha256 cellar: :any, arm64_sequoia:     "8d4e56b209da8889f34fbc3c994a57963cb90e28b68050a274ed21c8cc03e768"
    sha256 cellar: :any, arm64_linux:       "eac2169ccdedca012ecc6c2b4a632e3017f59f081558836719f96193458bbca5"
    sha256 cellar: :any, x86_64_linux:      "fec09e6ad25dc8593515e66ef98253c4509f795e77323abe1edb25944e0f041d"
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
