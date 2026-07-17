class LibtorrentRasterbarAT20 < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.13/libtorrent-rasterbar-2.0.13.tar.gz"
  sha256 "892cb75c06318e2420de0faf9f63a908069d3d237676e2459fd30abe0cb3b1bf"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(2\.0(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    sha256 cellar: :any, arm64_tahoe:   "347cbb7d1a4a42b23a8b8cb2e3df12f2bb42350c340044c2cc0581a0c8d65d5d"
    sha256 cellar: :any, arm64_sequoia: "1d0b3308623e784020e4e24a8e57487808141b63c478d514e65765149da3665a"
    sha256 cellar: :any, arm64_sonoma:  "ff761eff2ae2a9db33dd09580a4692d6b347c4853b517018971bfae5ada6eb12"
    sha256 cellar: :any, tahoe:         "fefb1ccfcd5657b6c6bfbaf1d093bd742bade5a61b29a1a6812909e067476123"
    sha256 cellar: :any, sequoia:       "6641dc008744b356875cd8b77640bc68ed90e6a0b8f70febd6a9e899b72d91d9"
    sha256 cellar: :any, arm64_linux:   "858166d6cef9032e0b094c04f58856898822be94f90f09d5d8f5b84410874845"
    sha256 cellar: :any, x86_64_linux:  "bc074cfb4de7879375ed7f81bbc6943b4878ef2b8f4c27953ef53b7e63334299"
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
      -DCMAKE_CXX_STANDARD=14
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
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
