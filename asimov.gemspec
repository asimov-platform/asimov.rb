# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = "asimov.rb"
  gem.homepage           = "https://sdk.asimov.so"
  gem.license            = "Unlicense"
  gem.summary            = "Asimov Software Development Kit (SDK) for Ruby"
  gem.description        = ""
  gem.metadata           = {
    'bug_tracker_uri'   => "https://github.com/AsimovPlatform/asimov.rb/issues",
    'changelog_uri'     => "https://github.com/AsimovPlatform/asimov.rb/blob/master/CHANGES.md",
    'documentation_uri' => "https://github.com/AsimovPlatform/asimov.rb/blob/master/README.md",
    'homepage_uri'      => gem.homepage,
    'source_code_uri'   => "https://github.com/AsimovPlatform/asimov.rb",
  }

  gem.author             = "Asimov AI"
  gem.email              = "support@asimov.so"

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CHANGES.md README.md UNLICENSE VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()

  gem.required_ruby_version = '>= 2.6'  # macOS 12+
  gem.add_development_dependency 'rake',  '>= 13'
  gem.add_development_dependency 'rspec', '>= 3.12'
  gem.add_development_dependency 'yard' , '>= 0.9'
  gem.add_runtime_dependency     'know'
end
