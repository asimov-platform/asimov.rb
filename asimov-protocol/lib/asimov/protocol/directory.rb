# This is free and unencumbered software released into the public domain.

##
# The directory of datasets on the ASIMOV Protocol.
class ASIMOV::Protocol::Directory
  ##
  # @param  [Integer, #to_i] block
  # @param  [Boolean] local
  # @yield  [dir]
  # @yieldparam [ASIMOV::Protocol::Directory] dir
  # @yieldreturn [void]
  # @return [ASIMOV::Protocol::Directory]
  def self.open(block: nil, local: false, &)
    # TODO: call the registry contract
    dir = self.new
    if block_given?
      yield dir
    else
      dir
    end
  end

  ##
  # @param  [String, #to_s] account_id
  # @return [ASIMOV::Protocol::Account]
  def find_account(account_id)
    ASIMOV::Protocol::Account.new(account_id)
  end

  ##
  # @param  [String, #to_s] dataset_id
  # @return [ASIMOV::Protocol::Dataset]
  def find_dataset(dataset_id)
    ASIMOV::Protocol::Dataset.new(dataset_id)
  end

  ##
  # @yield  [dataset]
  # @yieldparam [ASIMOV::Protocol::Dataset] dataset
  # @yieldreturn [void]
  # @return [void]
  def each_dataset(&block)
    return enum_for(__method__) unless block_given?
    self.datasets.each(&block)
  end

  ##
  # @return [Array<ASIMOV::Protocol::Dataset>]
  def datasets
    [] # TODO
  end
end # ASIMOV::Protocol::Directory
