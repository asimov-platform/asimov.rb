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
  #   p ASIMOV::Construct.count
  #
  # @return [Integer]
  def self.count
    self.each.count
  end

  ##
  # @example
  #   p ASIMOV::Construct.ids
  #
  # @return [Array<String>]
  def self.ids
    self.each.map(&:id).to_a
  end

  ##
  # @example
  #   ASIMOV::Construct.list(prefix: "isaac") do |construct|
  #     puts construct.name
  #   end
  #
  # @example
  #   p ASIMOV::Construct.list(prefix: "isaac").to_a
  #
  # @param  [String, #to_s] prefix
  # @yield [construct]
  # @yieldparam [ASIMOV::Construct] construct
  # @yieldreturn [void]
  # @return [Enumerator] if no block was given
  def self.list(prefix: nil, &block)
    return enum_for(__method__, prefix:) unless block_given?
    result = self.each
    result = result.filter { _1.id.start_with?(prefix.to_s) } if prefix
    result.each(&block)
  end

  ##
  # @example
  #   ASIMOV::Construct.each do |construct|
  #     puts construct.name
  #   end
  #
  # @yield [construct]
  # @yieldparam [ASIMOV::Construct] construct
  # @yieldreturn [void]
  # @return [Enumerator] if no block was given
  def self.each(&block)
    return enum_for(__method__) unless block_given?
    construct_dirs = ASIMOV::Config.each_construct_dir.to_a
    construct_dirs.filter! { _1.join("construct.kdl").readable? }
    construct_dirs.sort_by!(&:basename).each do |construct_path|
      block.call(self.parse(construct_path))
    end
  end

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
    return nil if !id
    id = id.is_a?(self.class) ? id.id : id.to_s
    result = self.parse(ASIMOV::Config.constructs_dir.join(id))
    result = block.call(result) if block_given?
    result
  rescue Errno::ENOENT => error
    nil
  end

  ##
  # @example
  #   ASIMOV::Construct.parse("asimov-constructs/isaac.asimov")
  #
  # @param  [Pathname, #to_s] path
  # @return [ASIMOV::Construct]
  def self.parse(path)
    manifest_path = Pathname(path).join("construct.kdl")
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

  ##
  # @return [String]
  def to_h
    {id:, names:, links:}
  end

  ##
  # @return [KDL::Document]
  def to_kdl
    require "kdl"
    KDL::Document.new([
      KDL::Node.new("construct", arguments: [self.id], children: [
        KDL::Node.new("name", children: self.names.map do |k, v|
          KDL::Node.new(k.to_s, arguments: [v])
        end),
        KDL::Node.new("links", children: self.links.map do |k, v|
          KDL::Node.new(k.to_s, arguments: [v])
        end),
      ]),
    ])
  end

  ##
  # @return [String]
  def to_json
    require "json"
    JSON.pretty_generate(self.to_h)
  end

  ##
  # @return [String]
  def to_yaml
    require "yaml"
    YAML.dump(self.to_h, stringify_names: true)
  end
end # ASIMOV::Construct
