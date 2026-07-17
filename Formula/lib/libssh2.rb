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
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "b6165ead2ab71d2b5bf7307ba1c3ff744caa318a1de72ece6a6b804138d96ebe"
    sha256 cellar: :any, arm64_sequoia: "706f4cd66901e96a8b0166d7486de28bb6d304e59b413ecb3e525b068e6348f2"
    sha256 cellar: :any, arm64_sonoma:  "07d3ab576f080af4f361f701b61ef7e65b8a0867af44af758281090b7c21fda3"
    sha256 cellar: :any, tahoe:         "d688b0068561220da92a6c43a213343a1ef0773161a526512716a4c2771b42e8"
    sha256 cellar: :any, sequoia:       "2eb4e61c78e70ed2a1665706eb6462ac7ab02a231ec7149f84d8d346755f149d"
    sha256 cellar: :any, arm64_linux:   "6ff481f0d25a05ecac62f024a1e42bef6c4e04119c5feb6727418aeb510f6811"
    sha256 cellar: :any, x86_64_linux:  "251bb99e6cddc292fd10556ffc05793f9a81664cb0859f186e16709f2333ff35"
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
