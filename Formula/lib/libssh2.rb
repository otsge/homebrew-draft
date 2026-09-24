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
    rebuild 3
    sha256 cellar: :any, arm64_golden_gate: "0b3ced12ab3742b005c872d4ffd1b127bdd3ada71403556711c2c8207b8c0e14"
    sha256 cellar: :any, arm64_tahoe:       "8cce5274a72e725404bf84c7374809966475092f06cdbd2806030d7c8f92c5be"
    sha256 cellar: :any, arm64_sequoia:     "3d8ba0e53008272dc9d40fd3c16f38067107cdda84841d4f200bd770f762d029"
    sha256 cellar: :any, arm64_linux:       "621b5d9d4c0e2d627debf8ac22de8b8fd30351ec4ffc9ad21f01c0a6c1875b58"
    sha256 cellar: :any, x86_64_linux:      "f7280e30489724b2fa2769c41c4a507be6a24e393437e0b1e23d7ad7147302fc"
  end

  head do
    url "https://github.com/libssh2/libssh2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
