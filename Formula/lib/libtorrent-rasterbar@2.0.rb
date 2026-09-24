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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "cee23a67389f3b723640a6c3a1946abd4b5c678977e1a72b8f30e39ab4a28c58"
    sha256 cellar: :any, arm64_tahoe:       "6eb3d2d9758db50c4b162a38571be35d824badb0f702a5f7f589d688baa21e5c"
    sha256 cellar: :any, arm64_sequoia:     "68f983558ea1e98b0dfe847eb0315d04edd6bb42e994cf2a99d1263a3f600fc4"
    sha256 cellar: :any, arm64_linux:       "c3363db18b5f97ef9ac1ecea3e4586676a6f981c529f835f39bdc29e03703fa7"
    sha256 cellar: :any, x86_64_linux:      "c1108fb9bb217be84a5fae37bf93b6f73bf35ea623ac11f710078ecd0bd944f7"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@3"
  depends_on "python@3.14"

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

    system "python3.14", "-c", "import libtorrent"
  end
end
