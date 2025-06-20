Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = "asimov-module"
  gem.homepage           = "https://sdk.asimov.sh"
  gem.license            = "Unlicense"
  gem.summary            = "ASIMOV Software Development Kit (SDK) for Ruby"
  gem.description        = ""
  gem.metadata           = {
    'bug_tracker_uri'   => "https://github.com/asimov-platform/asimov.rb/issues",
    'changelog_uri'     => "https://github.com/asimov-platform/asimov.rb/blob/master/CHANGES.md",
    'documentation_uri' => "https://rubydoc.info/gems/asimov-module",
    'homepage_uri'      => gem.homepage,
    'source_code_uri'   => "https://github.com/asimov-platform/asimov.rb",
  }

  gem.author             = "ASIMOV Protocol"
  gem.email              = "support@asimov.systems"

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CHANGES.md README.md UNLICENSE VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()

  gem.required_ruby_version = '>= 3.2'
  gem.add_development_dependency 'rake',  '>= 13'
  gem.add_development_dependency 'rspec', '>= 3.12'
  gem.add_development_dependency 'yard' , '>= 0.9'
  gem.add_runtime_dependency     'asimov-config', gem.version
end
