#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

GEMSPEC = Gem::Specification.new do |gem|
  gem.name               = 'crm114'
  gem.version            = '1.0.2'
  gem.date               = '2009-12-20'
  gem.homepage           = 'http://crm114.rubyforge.org/'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'Ruby interface to the CRM114 Controllable Regex Mutilator text classification engine.'
  gem.description        = <<-EOF
    CRM114.rb is a Ruby interface to the CRM114 Controllable Regex
    Mutilator, an advanced and fast text classifier that uses sparse binary
    polynomial matching with a Bayesian Chain Rule evaluator and a hidden
    Markov model to categorize data with up to a 99.87% accuracy.
  EOF
  gem.rubyforge_project  = 'crm114'

  gem.author             = 'Arto Bendiken'
  gem.email              = 'arto.bendiken@gmail.com'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(UNLICENSE AUTHORS README README.md Rakefile VERSION lib/crm114.rb test/test_code_or_text.rb test/test_crm114.rb)
  gem.files             -= %w(README.md) # only for GitHub
  gem.bindir             = %q(bin)
  gem.executables        = %w()
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w(test/test_code_or_text.rb test/test_crm114.rb)
  gem.has_rdoc           = false

  gem.required_ruby_version    = '>= 1.8.2'
  gem.requirements             = ['CRM114']
  gem.add_development_dependency 'bendiken-rakefile' # http://github.com/bendiken/rakefile
  gem.post_install_message     = nil
end
