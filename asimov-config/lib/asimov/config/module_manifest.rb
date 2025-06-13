# This is free and unencumbered software released into the public domain.

require 'yaml'

module ASIMOV; end
module ASIMOV::Config; end

##
# ASIMOV module manifest.
class ASIMOV::Config::ModuleManifest
  ##
  # @param [Pathname, #to_s] path
  # @return [ModuleManifest]
  def self.load_file(path)
    self.load_yaml(File.read(path.to_s))
  end

  ##
  # @param [String, #to_s] yaml
  # @return [ModuleManifest]
  def self.load_yaml(yaml_string)
    self.new(YAML.safe_load(yaml_string, symbolize_names: true))
  end

  ##
  # @return [String]
  attr_reader :name
  def name() @yaml[:name] end

  ##
  # @return [String]
  attr_reader :label
  def label() @yaml[:label] end

  ##
  # @return [String]
  attr_reader :summary
  def summary() @yaml[:summary] end

  ##
  # @return [Array<String>]
  attr_reader :links
  def links() @yaml[:links] end

  ##
  # @return [Hash{Symbol => Object}]
  attr_reader :provides
  def provides() @yaml[:provides] end

  ##
  # @return [Hash{Symbol => Object}]
  attr_reader :handles
  def handles() @yaml[:handles] end

  ##
  # @param [Hash{Symbol => Object}] yaml
  # @return [void]
  def initialize(yaml)
    @yaml = yaml
  end

  ##
  # @return [Hash{Symbol => Object}]
  def to_h
    @yaml
  end
end # ASIMOV::Config::ModuleManifest
