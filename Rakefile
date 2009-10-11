require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run spec tests.'
task :default => :test

desc 'Test the i18n_tools plugin.'
task :test do |t|
  system "spec #{File.dirname(__FILE__) + '/spec'} -cfn"
end

desc 'Generate documentation for the i18n_tools plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'I18n-tools'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
