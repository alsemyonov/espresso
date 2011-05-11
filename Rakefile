require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install rcov"
  end
end

begin
  require 'reek/rake/task'
  Reek::Rake::Task.new do |test|
    test.ruby_opts << '-rubygems'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.patterns << 'lib/*.rb' << 'lib/**/*.rb'
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run reek, you must: sudo gem install roodi"
  end
end

task :test => :check_dependencies

task :default => :test

begin
  require 'yard'
  desc 'Generate documentation'
  YARD::Rake::YardocTask.new(:doc) do |yard|
    yard.options << '--no-private'
  end
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

task :doc => :yard

desc "Release to github and rubygems, install"
task :bump => %w(release install)
