class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://wiki.freedesktop.org/www/Software/HarfBuzz/"
  url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.4.1.tar.bz2"
  sha256 "85a27fab639a1d651737dcb6b69e4101e3fd09522fdfdcb793df810b5cb315bd"

  bottle do
    sha256 "eb56208c0eb2f0f203674df47188135c886f5d436daa3187f9b8d91f13c18c36" => :sierra
    sha256 "e6a9c1675f3eb0deb0514a0b6b218f66ef7955e246c2303b2d11372f091e854d" => :el_capitan
    sha256 "462dc8e7e42bd604cdb8731c7ad7e0ef7b2ba52c00916edb18fe972202479e77" => :yosemite
  end

  head do
    url "https://github.com/behdad/harfbuzz.git"

    depends_on "ragel" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-cairo", "Build command-line utilities that depend on Cairo"

  depends_on "pkg-config" => :build
  depends_on "freetype" => :recommended
  depends_on "glib" => :recommended
  depends_on "gobject-introspection" => :recommended
  depends_on "icu4c" => :recommended
  depends_on "cairo" => :optional
  depends_on "graphite2" => :optional

  resource "ttf" do
    url "https://github.com/behdad/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-coretext=yes
      --enable-static
    ]

    if build.with? "cairo"
      args << "--with-cairo=yes"
    else
      args << "--with-cairo=no"
    end

    if build.with? "freetype"
      args << "--with-freetype=yes"
    else
      args << "--with-freetype=no"
    end

    if build.with? "glib"
      args << "--with-glib=yes"
    else
      args << "--with-glib=no"
    end

    if build.with? "gobject-introspection"
      args << "--with-gobject=yes" << "--enable-introspection=yes"
    else
      args << "--with-gobject=no" << "--enable-introspection=no"
    end

    if build.with? "graphite2"
      args << "--with-graphite2=yes"
    else
      args << "--with-graphite2=no"
    end

    if build.with? "icu4c"
      args << "--with-icu=yes"
    else
      args << "--with-icu=no"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
