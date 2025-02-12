Gem::Specification.new do |gem|
  gem.version            = File.read('../VERSION').chomp
  gem.date               = File.mtime('../VERSION').strftime('%Y-%m-%d')

  gem.name               = "asimov.rb"
  gem.homepage           = "https://sdk.asimov.so"
  gem.license            = "Unlicense"
  gem.summary            = "ASIMOV Software Development Kit (SDK) for Ruby"
  gem.description        = ""
  gem.metadata           = {
    'bug_tracker_uri'   => "https://github.com/asimov-platform/asimov.rb/issues",
    'changelog_uri'     => "https://github.com/asimov-platform/asimov.rb/blob/master/CHANGES.md",
    'documentation_uri' => "https://rubydoc.info/gems/asimov.rb",
    'homepage_uri'      => gem.homepage,
    'source_code_uri'   => "https://github.com/asimov-platform/asimov.rb",
  }

  gem.author             = "ASIMOV Protocol"
  gem.email              = "support@asimov.so"

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(../AUTHORS ../CHANGES.md ../README.md ../UNLICENSE ../VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()

  gem.required_ruby_version = '>= 3.0'
  gem.add_development_dependency 'rake',  '>= 13'
  gem.add_development_dependency 'rspec', '>= 3.12'
  gem.add_development_dependency 'yard' , '>= 0.9'
  gem.add_runtime_dependency     'asimov-config', gem.version
  gem.add_runtime_dependency     'asimov-construct', gem.version
  gem.add_runtime_dependency     'asimov-dataset', gem.version
  gem.add_runtime_dependency     'asimov-flow', gem.version
  gem.add_runtime_dependency     'asimov-module', gem.version
  gem.add_runtime_dependency     'asimov-ontology', gem.version
  gem.add_runtime_dependency     'asimov-protocol', gem.version
  gem.add_runtime_dependency     'asimov-sdk', gem.version
  gem.add_runtime_dependency     'asimov-vault', gem.version
  gem.add_runtime_dependency     'know'
end
