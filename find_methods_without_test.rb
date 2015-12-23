require "pp"
# require "awesome_print"
# require "pry"

class MethodFinder
  RUBY_DIR = "/Users/igarashi/github_repos/github.com/ruby/ruby"
  RUBY_TEST_PATH = "test/ruby"
  attr_accessor :class_name

  def initialize(class_name: nil)
    @class_name = class_name
    @class_instance = eval("#{class_name}.new")
    @class = @class_instance.class
  end

  def methods_by_instance
    @class.instance_methods(false)
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
    @methods_by_instance = methods_by_instance.map(&:to_s)
    @testless_methods = []
    @methods_by_instance.each do |m|
      @testless_methods << m unless test_exists?(m)
    end
    @testless_methods
  end

  private

  def test_exists?(testee)
    @methods_by_file_name.each do |m|
      return true if m == testee
      begin
        return true if m =~ /#{testee}/
      rescue RegexpError => e
        p e
        return false
      end
    end
    false
  end

end

pp MethodFinder.new(class_name: "String").run
# TODO aliasなメソッド名
# TODO 全該当ファイル

