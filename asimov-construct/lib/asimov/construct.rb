# This is free and unencumbered software released into the public domain.

require "asimov/config"
require "kdl"

class ASIMOV::Construct
  ##
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
    manifest = KDL.load_file(path.join("construct.kdl"))
    manifest_root = manifest.nodes.first
    case manifest_root.name
      when "construct"
        construct_id = manifest_root.arguments.first
        construct_names, construct_links = {}, {}
        manifest_root.children.each do |node|
          case node.name
            when "name", "names"
              construct_names = node.children.inject({}) do |memo, node|
                memo[node.name.to_sym] = node&.arguments&.first&.value
                memo
              end
            when "links"
              construct_links = node.children.inject({}) do |memo, node|
                memo[node.name.to_sym] = node&.arguments&.first&.value
                memo
              end
          end
        end
        self.new(construct_id, names: construct_names, links: construct_links)
      else
        raise ArgumentError, "invalid construct manifest: #{manifest_root.name}"
    end
  end

  ##
  # @param  [String, #to_s] id
  # @param  [Hash{Symbol => String}, #to_h] names
  # @param  [Hash{Symbol => String}, #to_h] links
  def initialize(id, names: {}, links: {})
    @id = id.to_s
    @names = names.to_h
    @links = links.to_h
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
end # ASIMOV::Construct
