require 'paint'

class GemUpdateRow
  attr_accessor :name, :locked_version, :available_version, :dependency

  def initialize(name, locked_version, available_version, dependency)
    @name = name
    @locked_version = locked_version
    @available_version = available_version
    @dependency = dependency
  end

  def name_colored
    Paint[name, "gold"]
  end

  def locked_version_colored
    Paint[locked_version, "white"]
  end

  def available_version_colored
    Paint[available_version, "white"]
  end

  def dependency_colored
    Paint[dependency, "green"]
  end

  def to_a
    [name.to_s, locked_version, '>', available_version, dependency.to_s]
  end

  # def to_a
  #   [name_colored, locked_version_colored, available_version_colored, dependency_colored]
  # end
end