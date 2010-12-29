require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the aws_imageshack plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the aws_imageshack plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'AwsImageshack'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

spec = Gem::Specification.new do |s|
  s.name = "aws_imageshack"
  s.version = "0.1.0"
  s.author = "Denis FABIEN"
  s.email = "denis@miseajour.net"
  s.homepage = "http://www.miseajour.net/une-gem-pour-surveiller-la-modification-des-champs.html"
  s.platform = Gem::Platform::RUBY
  s.summary = "Use ImageShack to host your image, with un ajax upload form"
  s.files = FileList[
								'[a-zA-Z]*',
							  'lib/**/*']
  s.require_path = "lib"
  s.has_rdoc = false
  s.extra_rdoc_files = ["README"]
end

desc 'Turn this plugin into a gem.'
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
