GEM = gem
RAKE = rake
RSPEC = rspec

all: asimov.gemspec
	$(GEM) build $<

check:

clean:
	rm -f *~ asimov.rb-*.gem

.PHONY: all check clean
