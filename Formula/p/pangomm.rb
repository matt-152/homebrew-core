class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.50/pangomm-2.50.1.tar.xz"
  sha256 "ccc9923413e408c2bff637df663248327d72822f11e394b423e1c5652b7d9214"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9c50c1b4379363deed56bf0926af5238935a9aa9e015a829dc74156afe63cc43"
    sha256 cellar: :any, arm64_ventura:  "240d818a0f389065c06f1b6cb55a7a65b28181717dd4ee5017d93bf7e8575608"
    sha256 cellar: :any, arm64_monterey: "cd508f02963834ff60dc5b02ccd2f6516373c6f63698b153bae6f5521b6fbe56"
    sha256 cellar: :any, arm64_big_sur:  "8133d833f805dcf72e25e766fe02feecd52ba937bc5ea6fd9a49cedad914fc41"
    sha256 cellar: :any, sonoma:         "4c143bd61e4c1246e6a711579e4947e67609c42518d700018ed745425ec87b60"
    sha256 cellar: :any, ventura:        "3243026755b4a058991bb6bcdbbe8a2504255e3c324eafc2c55a538c2ac6e7d8"
    sha256 cellar: :any, monterey:       "e460a123e6a56d4ceea894435fa9ac65acc3f9875708f9d24b0f5a75e11d43b2"
    sha256 cellar: :any, big_sur:        "9044bfea7d53b7916e7e5ba23da64b71b4a3b01e505553af8b07760a889b4f47"
    sha256 cellar: :any, catalina:       "72142eb96fbd86564dabeab768e93a0e7b271c328a25ed9288eb129779e983d1"
    sha256               x86_64_linux:   "50fbc4de8c8a95af450e0ee638e02e8a20ac5ace7cb15a2d334143b1bade658d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairomm"
  depends_on "glibmm"
  depends_on "pango"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs pangomm-2.48").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
