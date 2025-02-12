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
  # @return [Pathname]
  def self.constructs_dir
    self.path.join("constructs")
  end

  ##
  # @return [Pathname]
  def self.modules_dir
    self.path.join("modules")
  end

  ##
  # @yield  [path]
  # @yieldparam [Pathname] path
  # @yieldreturn [void]
  # @return [Enumerator]
  def self.each_construct_dir(&block)
    return enum_for(__method__) unless block_given?
    self.each_dir(self.constructs_dir, &block)
  end

  ##
  # @yield  [path]
  # @yieldparam [Pathname] path
  # @yieldreturn [void]
  # @return [Enumerator]
  def self.each_module_dir(&block)
    return enum_for(__method__) unless block_given?
    self.each_dir(self.modules_dir, &block)
  end

  protected

  ##
  # @param  [Pathname, #to_s] parent
  # @yield  [path]
  # @yieldparam [Pathname] path
  # @yieldreturn [void]
  # @return [Enumerator]
  def self.each_dir(parent, &block)
    return enum_for(__method__, parent) unless block_given?
    Pathname(parent).each_child do |path|
      next if path.basename.to_s[0] == '.'
      next if path.symlink? # omit aliases
      next unless path.directory?
      block.call(path)
    end
  end
end # ASIMOV::Config
