require 'test/unit'
require 'tempfile'
require 'fileutils'
require 'rubygems'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'pindah_cli'))

class PindahCLITest < Test::Unit::TestCase
  def setup
    $local_pwd ||= File.expand_path(File.dirname(__FILE__))
    @project_path = File.expand_path(Tempfile.new('pindah').path + ".d")
    FileUtils.mkdir_p @project_path
    Dir.chdir @project_path
    def PindahCLI.log(msg); end # nop
  end

  def teardown
    FileUtils.rm_rf @project_path
  end

  def test_create_should_create_basic_project_structure
    PindahCLI.create('tld.pindah.testapp', '.')

    directories = %w{ src/tld/pindah/testapp bin libs res
                      res/drawable-hdpi res/drawable-ldpi
                      res/drawable-mdpi res/layout res/values }

    directories.each do |d|
      expected = File.join(@project_path, d)
      assert File.directory?(expected), "Expected #{expected.inspect} to be a directory."
    end
  end



  def test_create_should_create_an_activity_if_desired
    PindahCLI.create('tld.pindah.testapp', '.', 'HelloWorld')

    expected = File.read(File.join($local_pwd,
                                   'fixtures',
                                   'HelloWorld.mirah'))
    actual   = File.read(File.join(@project_path,
                                   'src',
                                   'tld',
                                   'pindah',
                                   'testapp',
                                   'HelloWorld.mirah'))
    assert_equal expected, actual
  end

  def test_create_should_create_an_android_manifest_with_an_activity_specified
    PindahCLI.create('tld.pindah.testapp', 'subdir', 'HelloWorld')

    expected = File.read(File.join($local_pwd,
                                   'fixtures',
                                   'AndroidManifest.xml.with-activity'))
    actual   = File.read(File.join(@project_path,
                                   'subdir',
                                   'AndroidManifest.xml'))
    assert_equal expected, actual
  end

    def test_create_should_create_an_android_manifest_without_an_activity_specified
    PindahCLI.create('tld.pindah.testapp', 'subdir')

    expected = File.read(File.join($local_pwd,
                                   'fixtures',
                                   'AndroidManifest.xml.no-activity'))
    actual   = File.read(File.join(@project_path,
                                   'subdir',
                                   'AndroidManifest.xml'))
    assert_equal expected, actual
  end
end


# Added file wibble/AndroidManifest.xml
# Added file wibble/build.xml
# Added file wibble/res/layout/main.xml
# Added file wibble/res/values/strings.xml
# Added file wibble/src/com/test/wibble/Wibble.java

