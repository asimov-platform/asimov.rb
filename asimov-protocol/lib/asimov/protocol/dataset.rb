# This is free and unencumbered software released into the public domain.

##
# A dataset of knowledge graphs on the ASIMOV Protocol.
class ASIMOV::Protocol::Dataset
  GRAMMAR = %r{^([^/]+)/([^/]+)$}

  ##
  # @param [String, #to_s] id
  # @return [ASIMOV::Protocol::Dataset]
  def self.parse(id)
    id = id.to_s
    account, name = case id
      when ASIMOV::Protocol::Account::GRAMMAR then [$1, nil]
      when GRAMMAR then [$1, $2]
      else raise ArgumentError, "invalid dataset ID: #{id.inspect}"
    end
    self.new(account, name)
  end

  ##
  # @param [String, #to_s] account
  # @param [String, #to_s] name
  def initialize(account, name)
    @account, @name = account.to_s, name.to_s
  end

  ##
  # The account that owns this dataset.
  #
  # @return [ASIMOV::Protocol::Account]
  attr_reader :account
  def account
    ASIMOV::Protocol::Account.new(@account)
  end

  ##
  # The machine-readable name of this dataset.
  #
  # @return [String]
  attr_reader :name

  ##
  # @return [Pathname]
  def path
    self.account.path.join(self.name || 'default') # TODO
  end

  ##
  # @return [void]
  def each_graph(&block)
    [].each(&block) # TODO
  end

  ##
  # @return [String]
  def to_s
    [@account, @name].compact.join('/')
  end
  alias_method :id, :to_s

  ##
  # @param [String, #to_s] base_uri
  # @return [String]
  def to_uri(base_uri)
    "#{base_uri}/#{self.to_s}"
  end

  ##
  # @param [String, #to_s] base_uri
  # @return [RDF::Graph]
  def to_rdf(base_uri)
    require 'rdf'
    require 'rdf/vocab'

    include RDF
    include RDF::Vocab

    RDF::Graph.new do |graph|
      self_uri = RDF::URI(self.to_uri(base_uri)).normalize
      default_graph = RDF::Node.new
      graph << [self_uri, RDF.type, SD.Service]
      graph << [self_uri, RDFS.label, self.name]
      graph << [self_uri, SD.endpoint, self_uri]
      graph << [self_uri, SD.supportedLanguage, SD.SPARQL11Query]
      graph << [self_uri, SD.defaultDataset, self_uri]
      graph << [self_uri, RDF.type, SD.Dataset]
      graph << [self_uri, SD.defaultGraph, default_graph]
      graph << [default_graph, RDF.type, SD.Graph]
      graph << [default_graph, VOID.triples, 0]
    end
  end
end # ASIMOV::Protocol::Dataset
