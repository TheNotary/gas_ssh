lib = File.expand_path("../lib", __FILE__)
$:.unshift lib unless $:.include? lib

require "gas_ssh/version"

Gem::Specification.new do |s|
  s.name = "gas-ssh"
  s.version = GasSsh::VERSION
  s.authors = "Fredrik Wallgren"
  s.email = "fredrik.wallgren@gmail.com"
  s.homepage = "https://github.com/walle/gas-ssh"
  s.summary = "SSHpower your gas"
  s.description = "Adds SSH support to gas."

  s.rubyforge_project = s.name

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.textile LICENSE]

  s.add_dependency 'gas' # Must be more than 0.2.0
  s.add_dependency 'sshkey', '~> 1.2.2'
  s.add_dependency 'highline'
  s.add_dependency 'json'
  s.add_dependency 'jruby-openssl' if RUBY_PLATFORM == "java"

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rr'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'pry'

  s.files = Dir.glob("{bin,lib,spec,config}/**/*") + ['LICENSE', 'README.textile']
  s.executables = ['gas-ssh']
  s.require_path = ['lib']
end

