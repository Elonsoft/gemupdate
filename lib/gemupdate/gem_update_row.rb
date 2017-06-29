require 'paint'

class GemUpdateRow
  attr_accessor :name, :locked_version, :available_version

  def initialize(name)
    @name = name
    @locked_version = "1.4.4"
    @available_version = "1.5.1"
  end

  def name_colored
    Paint[locked_version, "gold"]
  end

  def locked_version_colored
    Paint[locked_version, "white"]
  end

  def available_version_colored
    Paint[available_version, "white"]
  end

  def to_a
    [name.to_s, locked_version, '>', available_version]
  end

  # def to_a
    # [name_colored, locked_version_colored, available_version_colored]
  # end
end