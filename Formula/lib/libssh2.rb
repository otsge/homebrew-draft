class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://libssh2.org/"
  url "https://libssh2.org/download/libssh2-1.11.1.tar.gz"
  mirror "https://github.com/libssh2/libssh2/releases/download/libssh2-1.11.1/libssh2-1.11.1.tar.gz"
  mirror "http://download.openpkg.org/components/cache/libssh2/libssh2-1.11.1.tar.gz"
  sha256 "d9ec76cbe34db98eec3539fe2c899d26b0c837cb3eb466a56b0f109cabf658f7"
  license "BSD-3-Clause"

  livecheck do
    url "https://libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    root_url "https://ghcr.io/v2/otsge/draft"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "5ebb09ec71851be57d29fe710ff7bb6c4e018e9a74c1d442f40341f28246b6a6"
    sha256 cellar: :any, arm64_sequoia: "9c0f5710c6ad94ae1b881d2ddb7af7a1324b17d73777f5af37036333de538cba"
    sha256 cellar: :any, arm64_sonoma:  "977ede34d05363071e6208e50737adc0be4df52cc434e663c8758b37526977c8"
    sha256 cellar: :any, tahoe:         "1becb8cea2291ce2315fae7abe649988e4c85a8cf36543590880939d0c3e8690"
    sha256 cellar: :any, sequoia:       "2e3d0daf1a00babb3436c38ebc22a578c45441130ad2e5eb5f08bfb36a14c292"
    sha256 cellar: :any, arm64_linux:   "dba00736c73015f2e754c00120d52ad48e47a45a616b5ccf6f836a77602e478d"
    sha256 cellar: :any, x86_64_linux:  "7041db1e76c4ceb4b7b6a25aadee0b2111d75fca168ac4863ac9f47dce5e6fbf"
  end

  head do
    url "https://github.com/libssh2/libssh2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "otsge/draft/openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{formula_opt_prefix("openssl@4")}
    ]

    system "./buildconf", "--force" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end
