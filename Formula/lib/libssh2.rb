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
    sha256 cellar: :any, arm64_tahoe:   "02d7b1e65c7d2c33c5e765470f4e4ea69c8042f5a415758a37a63bb4624740d8"
    sha256 cellar: :any, arm64_sequoia: "23116933324de82c9383442d74c7f21d2c3e46dd3a211d3031272d9f9ea6416a"
    sha256 cellar: :any, arm64_sonoma:  "15ccabc4ee1fab25c131121edfd529f12c9a2e58359e4368a5745737206476a1"
    sha256 cellar: :any, tahoe:         "6d80f792dc6ad5ee78aecb083fdb2fc487e5c4881a895b9e0603c15dfbcbd9a2"
    sha256 cellar: :any, sequoia:       "7d73eb5546822ff7c9e87cd9b2c19f9e7f943db3bcae53ea9642c562d17ded64"
    sha256 cellar: :any, arm64_linux:   "c765cf569412923e5691a78052928fe2b71442c6fc0e7758930e12855c4725f2"
    sha256 cellar: :any, x86_64_linux:  "47be5fc94f19b75745b0ad726d67d0da91e74421f2446a3adecfa6caa6204117"
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
      --with-libssl-prefix=#{Formula["openssl@4"].opt_prefix}
    ]

    system "./buildconf" if build.head?
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
