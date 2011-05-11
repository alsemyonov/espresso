# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'espresso/version'

Gem::Specification.new do |s|
  s.name        = %q{espresso}
  s.version     = Espresso::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Alexander Semyonov']
  s.email       = ['al@semyonov.us']
  s.homepage    = 'http://github.com/alsemyonov/espresso'
  s.summary     = %q{Rails extender to simplify rails development}
  s.description = %q{Useful templates for controller and model functions}

  s.rubyforge_project = 'espresso'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency('activesupport', '~> 3.0.7')
  s.add_runtime_dependency('activerecord', '~> 3.0.7')
  s.add_runtime_dependency('actionpack', '~> 3.0.7')
  s.add_runtime_dependency('inherited_resources', '~> 1.2.2')

  s.add_development_dependency('shoulda', '>= 0')
  s.add_development_dependency('redgreen', '>= 0')
end
