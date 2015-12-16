require "awesome_print"

class MethodFinder
  RUBY_DIR = "/Users/igarashi/github_repos/github.com/ruby/ruby"
  RUBY_TEST_PATH = "test/ruby"
  attr_accessor :class_name

  def initialize(class_name: nil)
    @class_name = class_name
  end

  def methods_by_instance
  end

  def methods_by_file_name()
    file_array = "test_#{@class_name.downcase}.rb"
    file = File.join(RUBY_DIR, RUBY_TEST_PATH, file_array)
    methods = []
    File.open(file, "r") do |f|
      f.each_line do |line|
        methods << $1 if line =~ /\A\s*def\s+(.+)\s+/
      end
    end
    target_test_methods = methods.map{ |x| x =~ /^test_(.+)\z/ ? $1 : nil }.compact.sort
  end

  def run
    @methods_by_file_name = methods_by_file_name
  end
end

ap MethodFinder.new(class_name: "Array").run
# TODO Array.new.instance_methods(false)と比較
# TODO 全該当ファイル
