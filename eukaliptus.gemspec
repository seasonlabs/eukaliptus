# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "eukaliptus/version"

Gem::Specification.new do |s|
  s.name        = "eukaliptus"
  s.version     = Eukaliptus::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["season", "victorcoder"]
  s.email       = ["victorcoder@gmail.com"]
  s.homepage    = "http://github.com/seasonlabs/eukaliptus"
  s.summary     = %q{Eukaliptus Facebook API Helpers}
  s.description = %q{Eukaliptus is a set of helpers and bug fixes for browsers to help you build Facebook iframe applications or user fan tabs.}
  s.license     = "MIT"
  s.rubyforge_project = "eukaliptus"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'koala', '~> 1.0.0'
  
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rack-test'
end
