# This is free and unencumbered software released into the public domain.

require "asimov/config"

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
    self.new(path.basename) # TODO
  end

  ##
  # @param  [String, #to_s] id
  def initialize(id)
    @id = id.to_s
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
end # ASIMOV::Construct
