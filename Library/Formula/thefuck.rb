class Thefuck < Formula
  desc "Programatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://pypi.python.org/packages/source/t/thefuck/thefuck-2.3.tar.gz"
  sha256 "260da6b4c698871098f9939a88deedbb0761e72c2096ef3e25cb7773156cd0c0"

  head "https://github.com/nvbn/thefuck.git"

  bottle do
    cellar :any
    sha256 "9db866018e5970da5d491b5c1749878f458857252a6f4871b3815ce8e1e7a4fb" => :yosemite
    sha256 "aa922aeb46c01fe64d24bff40fd5a8aad247e5ffcbee60a63b643b048fa01f1e" => :mavericks
    sha256 "54a4501488d834d893006a5dd85a33e3cad590244f93483ff99c6778d7496d2c" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.1.tar.gz"
    sha256 "a0e9b96f1946975064724e242ac159f3260db24ffa591c3da0a355361a3a337f"
  end

  resource "pathlib" do
    url "https://pypi.python.org/packages/source/p/pathlib/pathlib-1.0.1.tar.gz"
    sha256 "6940718dfc3eff4258203ad5021090933e5c04707d5ca8cc9e73c94a7894ea9f"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-18.0.1.tar.gz"
    sha256 "4d49c99fd51edf22baa997fb6105b07482feaebcb174b7d348a4307c29264b94"
  end

  def install
    xy = Language::Python.major_minor_version "python"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[setuptools pathlib psutil colorama six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    Add the following to your .bash_profile, .bashrc or .zshrc:
      bash: eval "$(thefuck-alias)"

      Other shells: https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end

  test do
    assert_match /echo ok/, shell_output(bin/"thefuck echho ok")
  end
end
