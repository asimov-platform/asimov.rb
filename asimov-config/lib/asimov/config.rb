# This is free and unencumbered software released into the public domain.

require "pathname"

module ASIMOV; end

module ASIMOV::Config
  ##
  # @return [Pathname]
  def self.path
    Pathname(ENV["ASIMOV_HOME"] || "~/.asimov").expand_path
  end

  ##
  # @yield  [path]
  # @yieldparam [Pathname] path
  # @yieldreturn [void]
  # @return [Enumerator]
  def self.each_construct(&block)
    return enum_for(__method__) unless block_given?
    self.each_dir("constructs", &block)
  end

  ##
  # @yield  [path]
  # @yieldparam [Pathname] path
  # @yieldreturn [void]
  # @return [Enumerator]
  def self.each_module(&block)
    return enum_for(__method__) unless block_given?
    self.each_dir("modules", &block)
  end

  ##
  # @param  [String] kind
  # @yield  [path]
  # @yieldparam [Pathname] path
  # @yieldreturn [void]
  # @return [Enumerator]
  def self.each_dir(kind, &block)
    return enum_for(__method__, parent) unless block_given?
    self.path.join(kind.to_s).each_child do |path|
      next if path.basename.to_s[0] == '.'
      next unless path.directory?
      block.call(path)
    end
  end
end # ASIMOV::Config
