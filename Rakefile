require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "espresso"
    gem.summary = %Q{Rails extender to simplify rails development}
    gem.description = %Q{Useful templates for controller and model functions}
    gem.email = "rotuka@rotuka.com"
    gem.homepage = "http://github.com/krasivotokak/espresso"
    gem.authors = ["Alexander Semyonov"]
    gem.add_development_dependency "thoughtbot-shoulda"
    gem.add_dependency('searchlogic', '>= 2.2.3')
    gem.add_dependency('josevalim-inherited_resources', '>= 0.8.5')
    gem.add_dependency('mislav-will_paginate', '>= 2.3.11')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
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

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "espresso #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
