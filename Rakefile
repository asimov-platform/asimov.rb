require 'pathname'

task default: %w(release:prep)

namespace :release do
  task :prep do
    gem_paths.each do |gem_path|
      `rsync -a AUTHORS CHANGES.md README.md UNLICENSE VERSION #{gem_path}/`
    end
  end

  task :build do
    gem_paths.each do |gem_path|
      `gem build #{gem_path}/*.gemspec`
    end
  end

  task :push do
    gem_paths.each do |gem_path|
      `gem push #{gem_path}*.gem`
    end
  end
end

def gem_paths
  (Dir["asimov-*"].sort + %w(asimov)).map { Pathname(it) }.filter do |path|
    path.directory? && path.join('VERSION').exist?
  end
end
