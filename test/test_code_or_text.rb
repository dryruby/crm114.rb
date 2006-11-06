$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

require 'test/unit'
require 'crm114'

class TestCodeOrText < Test::Unit::TestCase

  def setup
   @path = File.dirname(__FILE__)
   @crm = Classifier::CRM114.new([:code, :text], :path => @path)
   assert_nothing_raised do
     Dir["#{@path}/../lib/*.rb"].each { |file| @crm.code! File.read(file) }
     ['CHANGELOG', 'README', 'LICENSE'].each { |file| @crm.text! File.read(file) }
   end
  end

  def teardown
    Dir["#{@path}/*.css"].each { |file| File.delete(file) }
  end

  def test_code
    assert @crm.code?('class DrStrangelove; def self.lesson; stop_worrying && love_the_bomb; end; end')
  end

  def test_text
    assert @crm.text?('This an interface to the Dr. Strangelove-inspired CRM114 Controllable Regex Mutilator.')
  end

end
