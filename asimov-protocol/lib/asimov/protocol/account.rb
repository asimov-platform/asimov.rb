# This is free and unencumbered software released into the public domain.

require "asimov/config"
require "pathname"

##
# A user account on the ASIMOV Protocol.
class ASIMOV::Protocol::Account
  GRAMMAR = %r{^([^/]+)$}

  ##
  # @param [String, #to_s] id
  # @return [ASIMOV::Protocol::Account]
  def self.parse(id)
    id = id.to_s
    unless GRAMMAR.match?(id)
      raise ArgumentError, "invalid account ID: #{id.inspect}"
    end
    self.new(id)
  end

  ##
  # @param [String, #to_s] id
  # @return [void]
  def initialize(id)
    @id = id.to_s
  end

  ##
  # @return [String]
  attr_reader :id

  ##
  # @return [ASIMOV::Protocol::Account]
  def parent
    return nil unless self.id.include?('.')
    self.class.new(self.id.split('.').drop(1).join('.'))
  end

  ##
  # @return [Pathname]
  def path
    base_path = ASIMOV::Config.path.join("datasets")
    base_path.join(*self.id.split('.').reverse)
  end

  ##
  # @return [String]
  def to_s
    self.id
  end

  ##
  # @param [String, #to_s] base_uri
  # @return [String]
  def to_uri(base_uri)
    "#{base_uri}/#{self.id}"
  end

  ##
  # @param [String, #to_s] base_uri
  # @return [RDF::Graph]
  def to_rdf(base_uri)
    require "rdf"
    RDF::Graph.new do |graph|
      self_uri = RDF::URI.new(self.to_uri(base_uri))
      # TODO
    end
  end

  ##
  # @param  [String, #to_s] dataset_name
  # @return [ASIMOV::Protocol::Dataset]
  def find_dataset(dataset_name)
    ASIMOV::Protocol::Dataset.new("#{self.id}/#{dataset_name}")
  end
end # ASIMOV::Protocol::Account
