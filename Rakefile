$:.unshift(File.expand_path(File.dirname(__FILE__) + '/lib'))

require 'rubygems'
require 'crm114'

PKG_NAME    = 'crm114'
PKG_VERSION = Classifier::CRM114::VERSION
PKG_DESC    = 'Ruby interface to the CRM114 Controllable Regex Mutilator text classification engine.'
PKG_URL     = 'http://crm114.rubyforge.org/'

PKG_AUTHOR  = 'Arto Bendiken'
PKG_EMAIL   = 'arto.bendiken@gmail.com'

##############################################################################

require 'hoe'

Hoe.new(PKG_NAME, PKG_VERSION) do |p|
  p.author = PKG_AUTHOR
  p.email = PKG_EMAIL
  p.url = PKG_URL
  p.summary = PKG_DESC
  p.description = p.paragraphs_of('README', 1).first
  p.changes = p.paragraphs_of('CHANGELOG', 0..1).join("\n\n")
  p.spec_extras = { :rdoc_options => ['--main', 'README'] }
end

##############################################################################

def egrep(pattern, files)
  Dir[files].each do |file|
    File.open(file).readlines.each_with_index do |line, lineno|
      puts "#{file}:#{lineno + 1}:#{line}" if line =~ pattern
    end
  end
end

desc 'Look for TODO and FIXME tags in the code base.'
task :todo do
  egrep /#.*(FIXME|TODO)/, '**/*.rb'
end
