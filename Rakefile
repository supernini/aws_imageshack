require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'

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
  s.version = "0.4.0"
  s.author = "Denis FABIEN"
  s.email = "denis@miseajour.net"
  s.add_dependency('multipart-post')
  s.homepage = "http://www.miseajour.net/une-gem-pour-surveiller-la-modification-des-champs.html"
  s.platform = Gem::Platform::RUBY
  s.summary = "Use ImageShack to host your image, with un ajax upload form"
  s.description = <<-EOF
    The gem allow to use imageshack to host your images. You just need to require and API key on imageshack
  EOF

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
