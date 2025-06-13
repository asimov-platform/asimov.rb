# This is free and unencumbered software released into the public domain.

require 'addressable/uri'

module ASIMOV; end
module ASIMOV::Config; end

##
# ASIMOV resolver.
class ASIMOV::Config::Resolver
  ##
  # @return [Hash{Symbol, Array<Symbol>}]
  attr_reader :url_protocols

  ##
  # @return [Hash{Regexp, Array<Symbol>}]
  attr_reader :url_patterns

  ##
  # @return [Hash{String, Array<Symbol>}]
  attr_reader :url_prefixes

  ##
  # @return [void]
  def initialize
    @url_protocols = {}
    @url_patterns = {}
    @url_prefixes = {}
  end

  ##
  # @param [ModuleManifest, #to_h] module_manifest
  # @return [void]
  def register_module!(module_manifest)
    module_manifest = module_manifest.to_h

    module_name = module_manifest[:name].to_sym
    module_handles = module_manifest[:handles] || {}

    (module_handles[:url_protocols] || []).each do |url_protocol|
      (@url_protocols[url_protocol.to_sym] ||= []) << module_name
    end

    (module_handles[:url_patterns] || []).each do |url_pattern|
      url_regexp = compile_url_pattern(url_pattern)
      (@url_patterns[url_regexp] ||= []) << module_name

      www_pattern = url_pattern.sub('https://', 'https://www.')
      next unless www_pattern != url_pattern
      www_regexp = compile_url_pattern(www_pattern)
      (@url_patterns[www_regexp] ||= []) << module_name
    end

    (module_handles[:url_prefixes] || []).each do |url_prefix|
      (@url_prefixes[url_prefix] ||= []) << module_name
      www_prefix = url_prefix.sub('https://', 'https://www.')
      (@url_prefixes[www_prefix] ||= []) << module_name
    end

    self
  end

  ##
  # @param [Addressable::URI, #to_s] input_url
  # @return [Symbol]
  def resolve_url(input_url)
    input_url_scheme = Addressable::URI.parse(input_url).scheme.to_sym
    input_url_string = input_url.to_s

    @url_protocols.each do |url_protocol, module_names|
      return module_names.last if url_protocol == input_url_scheme
    end

    @url_patterns.each do |url_pattern, module_names|
      return module_names.last if url_pattern === input_url_string
    end

    @url_prefixes.each do |url_prefix, module_names|
      return module_names.last if input_url_string.start_with?(url_prefix)
    end

    nil # no match
  end
  alias_method :resolve_uri, :resolve_url

  ##
  # @param [Addressable::URI, #to_s] input_url
  # @return [Array<Symbol>]
  def lookup_url(input_url)
    input_url_scheme = Addressable::URI.parse(input_url).scheme.to_sym
    input_url_string = input_url.to_s
    output_module_names = []

    @url_protocols.each do |url_protocol, module_names|
      output_module_names += module_names if url_protocol == input_url_scheme
    end

    @url_patterns.each do |url_pattern, module_names|
      output_module_names += module_names if url_pattern === input_url_string
    end

    @url_prefixes.each do |url_prefix, module_names|
      output_module_names += module_names if input_url_string.start_with?(url_prefix)
    end

    output_module_names.uniq
  end
  alias_method :lookup_uri, :lookup_url

  protected

  def compile_url_pattern(pattern)
    temp_pattern = pattern.gsub(/:([a-zA-Z_][a-zA-Z0-9_]*)/, 'PLACEHOLDER\1PLACEHOLDER')
    escaped_pattern = Regexp.escape(temp_pattern)
    final_pattern = escaped_pattern.gsub(/PLACEHOLDER([a-zA-Z_][a-zA-Z0-9_]*)PLACEHOLDER/, '(?<\1>[^/]+)')
    Regexp.new("\\A#{final_pattern}\\z")
  end
end # ASIMOV::Config::Resolver
