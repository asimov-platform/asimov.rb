# This is free and unencumbered software released into the public domain.

require "asimov/config"
require "kdl"
require "pathname"

class KDL::Document
  def deconstruct
    self.nodes
  end

  def deconstruct_keys(keys)
    keys.inject({}) do |result, key|
      result[key] = self[key]
      result
    end
  end
end # KDL::Document

class KDL::Node
  def deconstruct
    self.children
  end

  def deconstruct_keys(keys)
    {name:, arguments:, properties:, children:, type:}
  end
end # KDL::Node

class ASIMOV::Construct
  ##
  # @example
  #   ASIMOV::Construct.open("isaac.asimov") do |construct|
  #     puts construct.system_prompt
  #   end
  #
  # @param  [String, #to_s] id
  # @yield [construct]
  # @yieldparam [ASIMOV::Construct] construct
  # @yieldreturn [Object]
  # @return [ASIMOV::Construct] or `nil` if the construct does not exist
  def self.open(id, &block)
    result = self.parse(ASIMOV::Config.constructs_dir.join(id.to_s))
    result = block.call(result) if block_given?
    result
  rescue Errno::ENOENT => error
    nil
  end

  ##
  # @example
  #   ASIMOV::Construct.each do |construct|
  #     puts construct.name
  #   end
  #
  # @yield [construct]
  # @return [Enumerator] if no block was given
  def self.each(&block)
    return enum_for(__method__) unless block_given?
    construct_dirs = ASIMOV::Config.each_construct_dir.to_a
    construct_dirs.filter! { it.join("construct.kdl").readable? }
    construct_dirs.sort_by!(&:basename).each do |construct_path|
      block.call(self.parse(construct_path))
    end
  end

  ##
  # @param  [Pathname] path
  # @return [ASIMOV::Construct]
  def self.parse(path)
    manifest_path = path.join("construct.kdl")
    manifest = KDL.load_file(manifest_path)
    construct_kwargs = case manifest
      in [{name: "construct", arguments: [construct_id], children:}]
        children.inject({}) do |kwargs, node|
          case node
            in {name: "name", children:}
              kwargs[:names] = children.inject({}) do |result, node|
                result[node.name.to_sym] = node.arguments&.first&.value
                result
              end
            in {name: "links", children:}
              kwargs[:links] = children.inject({}) do |result, node|
                result[node.name.to_sym] = node.arguments&.first&.value
                result
              end
          end
          kwargs
        end
      else
        raise ArgumentError, "invalid construct manifest: #{manifest_path}"
    end
    self.new(construct_id, path:, **construct_kwargs)
  end

  ##
  # @param  [String, #to_s] id
  # @param  [Pathname] path
  # @param  [Hash{Symbol => String}, #to_h] names
  # @param  [Hash{Symbol => String}, #to_h] links
  def initialize(id, path: nil, names: {}, links: {})
    @id = id.to_s.freeze
    @path = path ? Pathname(path).freeze : nil
    @names = (names || {en: @id}).to_h.freeze
    @links = (links || {}).to_h.freeze
  end

  ##
  # @return [String]
  attr_reader :id

  ##
  # @return [Pathname]
  attr_reader :path

  ##
  # @return [String]
  attr_reader :name
  def name; self.names[:en]; end

  ##
  # @return [Hash{Symbol => String}]
  attr_reader :names

  ##
  # @return [Hash{Symbol => String}]
  attr_reader :links

  ##
  # @return [String]
  def system_prompt
    self.path.join("system.md").read.strip rescue nil
  end
end # ASIMOV::Construct
