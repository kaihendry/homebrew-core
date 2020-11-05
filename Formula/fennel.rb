class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.7.0.tar.gz"
  sha256 "5bb07b35d88840dfeaa90ed29c3d9282357d360b07efeb497901871d6710e59d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "49cd0ff7aaa69ada9d53d7d88694fff426eceaafe4e4e0b7836810be8255e4e9" => :catalina
    sha256 "fc21ba932ee4c3f9b1ee0fb64e7b8adfefe58e2135a840e8307ad2fb824ac8c3" => :mojave
    sha256 "d794b7069c8789f69e04ff0a46213667a38ab67c00ee3186ddb42a4dd40686a0" => :high_sierra
  end

  depends_on "lua"

  def install
    system "make", "fennel"
    bin.install "fennel"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
