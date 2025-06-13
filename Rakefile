GEM_PATHS = Dir["asimov-*"].sort + %w(asimov)
GEM_ASSETS = %w(AUTHORS CHANGES.md README.md UNLICENSE VERSION)

RSYNC = ENV['RSYNC'] || 'rsync'
VERSION = File.read('VERSION').chomp

task default: %w(release:prep)

namespace :gems do
  task :list do
    gems.each { |gem| puts gem.name }
  end

  task :yank do
    gems.each do |gem|
      warn `gem yank #{gem.name} -v 25.0.0.dev.3`
    end
  end
end

namespace :release do
  task :prep do
    gems.each do |gem|
      `#{RSYNC} -a #{GEM_ASSETS.join(' ')} #{gem.path}/`
      `git add #{gem.path}/{#{GEM_ASSETS.join(',')}}`
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
    return nil unless it.directory? && it.join('VERSION').exist?
    gem_name = it.basename.to_s
    gem_name = 'asimov.rb' if gem_name == 'asimov'
    gem.new(gem_name, it)
  end
end
