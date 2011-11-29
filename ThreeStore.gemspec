# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ThreeStore/version"

Gem::Specification.new do |s|
  s.name        = "ThreeStore"
  s.version     = Threestore::VERSION
  s.authors     = ["Chenoa Siegenthaler"]
  s.email       = ["cowmanifestation@gmail.com"]
  s.homepage    = "http://github.com/cowmanifestation/threestore"
  s.summary     = 'Get files from a url and store them on s3'
  s.description = s.summary

  s.rubyforge_project = "ThreeStore"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('aws-s3')
end
