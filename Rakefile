require 'pathname'

task default: %w(release:prep)

namespace :release do
  task :prep do
    Dir["asimov-*"].map { Pathname(it) }.each do |path|
      next unless path.directory? && path.join('VERSION').exist?
      `rsync -a AUTHORS CHANGES.md README.md UNLICENSE VERSION #{path}/`
    end
  end
end
