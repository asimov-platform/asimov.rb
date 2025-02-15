GEM_PATHS = Dir["asimov-*"].sort + %w(asimov)
GEM_ASSETS = %w(AUTHORS CHANGES.md README.md UNLICENSE VERSION)

RSYNC = ENV['RSYNC'] || 'rsync'
VERSION = File.read('VERSION').chomp

task default: %w(release:prep)

namespace :release do
  task :prep do
    gems.each do |gem|
      `#{RSYNC} -a #{GEM_ASSETS.join(' ')} #{gem.path}/`
    end
  end

  task :build do
    gems.each do |gem|
      warn `gem -C #{gem.path} build *.gemspec`
    end
  end

  task :push do
    gems.each do |gem|
      warn `gem push #{gem.path}/*.gem`
    end
  end
end

def gems
  require 'pathname'
  gem = Struct.new(:name, :path)
  GEM_PATHS.map { Pathname(it) }.filter_map do
    gem.new(it.basename.to_s, it) if it.directory? && it.join('VERSION').exist?
  end
end
