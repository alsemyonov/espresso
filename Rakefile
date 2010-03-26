require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'espresso'
    gem.summary = %Q{Rails extender to simplify rails development}
    gem.description = %Q{Useful templates for controller and model functions}
    gem.email = 'rotuka@tokak.ru'
    gem.homepage = 'http://github.com/krasivotokak/espresso'
    gem.authors = ['Alexander Semyonov']
    gem.add_dependency('activesupport', '~> 2.3.5')
    gem.add_dependency('activerecord', '~> 2.3.5')
    gem.add_dependency('actionpack', '~> 2.3.5')
    gem.add_dependency('inherited_resources', '~> 1.0.5')
    gem.add_development_dependency('shoulda')
    gem.add_development_dependency('redgreen')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |yard|
    yard.options << '--no-private'
  end
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

desc 'Generate documentation'
task :doc => :yard

desc "Bump patch version and release to github and gemcutter"
task :bump => %w(version:bump:patch release gemcutter:release install)
