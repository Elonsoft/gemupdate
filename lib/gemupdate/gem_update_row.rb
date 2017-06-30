class GemUpdateRow
  attr_accessor :name, :locked_version, :available_version, :dependency

  def initialize(name, locked_version, available_version, dependency)
    @name = name
    @locked_version = locked_version
    @available_version = available_version
    @dependency = dependency
  end

  def name_colored
    Paint[name, 'gold']
  end

  def locked_version_colored
    Paint[locked_version, 'white']
  end

  def available_version_colored
    Paint[available_version, 'white']
  end

  def dependency_colored
    Paint[dependency, 'green']
  end

  def to_a
    [name.to_s, locked_version, '>', available_version, dependency.to_s]
  end

  # converts to colored table like structure to print in console
  def self.to_ask_options(gem_update_rows)
    options = CommandLineQueryUtils.colorize_options(
      CommandLineQueryUtils.add_spaces_to_options(gem_update_rows))
    default_options = [false] * gem_update_rows.length

    [options, default_options]
  end

  # convert from bundle gemspec to GemUpdateRow
  def self.from_gem_spec(gem)
    current_spec = gem[:current_spec]
    active_spec = gem[:active_spec]
    dependency = gem[:dependency]

    spec_version = "#{active_spec.version}#{active_spec.git_version}"
    current_version = "#{current_spec.version}#{current_spec.git_version}"

    dependency_version = if dependency && dependency.specific?
                           dependency.requirement
                         else
                           '-'
                         end

    new(
      active_spec.name,
      current_version,
      spec_version,
      dependency_version
    )
  end

end