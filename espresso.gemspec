# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{espresso}
  s.version = "0.0.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander Semyonov"]
  s.date = %q{2009-09-01}
  s.description = %q{Useful templates for controller and model functions}
  s.email = %q{rotuka@rotuka.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "espresso.gemspec",
     "init.rb",
     "lib/espresso.rb",
     "lib/espresso/helpers.rb",
     "lib/espresso/locales/en.yml",
     "lib/espresso/locales/ru.yml",
     "lib/espresso/model.rb",
     "lib/espresso/objects_controller.rb",
     "test/espresso_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/krasivotokak/espresso}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Rails extender to simplify rails development}
  s.test_files = [
    "test/espresso_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<searchlogic>, [">= 2.2.3"])
      s.add_runtime_dependency(%q<josevalim-inherited_resources>, [">= 0.8.5"])
      s.add_runtime_dependency(%q<mislav-will_paginate>, [">= 2.3.11"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<searchlogic>, [">= 2.2.3"])
      s.add_dependency(%q<josevalim-inherited_resources>, [">= 0.8.5"])
      s.add_dependency(%q<mislav-will_paginate>, [">= 2.3.11"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<searchlogic>, [">= 2.2.3"])
    s.add_dependency(%q<josevalim-inherited_resources>, [">= 0.8.5"])
    s.add_dependency(%q<mislav-will_paginate>, [">= 2.3.11"])
  end
end
