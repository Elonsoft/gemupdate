require 'bundler'
require 'inquirer'
require 'paint'
require 'bundler/cli'
require 'bundler/cli/update'

require_relative './gemupdate/gem_update_row.rb'

class Gemupdate

  def self.run(gemfile_lock_path)

    check_for_deployment_mode

    Bundler.definition.validate_runtime!
    current_specs = Bundler.ui.silence { Bundler.definition.resolve }
    current_dependencies = {}
    Bundler.ui.silence do
      Bundler.load.dependencies.each do |dep|
        current_dependencies[dep.name] = dep
      end
    end

    definition = Bundler.definition(true)

    definition_resolution = proc do
      definition.resolve_remotely!
    end

    definition_resolution.call

    puts ""
    outdated_gems_by_groups = {}
    outdated_gems_list = []

    # Loop through the current specs
    gemfile_specs, dependency_specs = current_specs.partition do |spec|
      current_dependencies.key? spec.name
    end

    (gemfile_specs + dependency_specs).sort_by(&:name).each do |current_spec|
      dependency = current_dependencies[current_spec.name]
      active_spec = retrieve_active_spec(definition, current_spec)

      gem_outdated = Gem::Version.new(active_spec.version) > Gem::Version.new(current_spec.version)
      next unless gem_outdated || (current_spec.git_version != active_spec.git_version)
      groups = nil
      if dependency
        groups = dependency.groups.join(", ")
      end

      outdated_gems_list << {:active_spec => active_spec,
                             :current_spec => current_spec,
                             :dependency => dependency,
                             :groups => groups}

      outdated_gems_by_groups[groups] ||= []
      outdated_gems_by_groups[groups] << {:active_spec => active_spec,
                                          :current_spec => current_spec,
                                          :dependency => dependency,
                                          :groups => groups}
    end

    if outdated_gems_list.empty?
      puts "Bundle up to date!\n"
    else
      specs = []
      outdated_gems_list.each do |gem|
        specs << add_gem(
            gem[:current_spec],
            gem[:active_spec],
            gem[:dependency]
        )
      end
      ask_user(specs)
      exit 1
    end
  end

  private

  def self.ask_user(update_rows)
    question = "Pick the gems you want to update... (space to select, enter to update selected)"
    options = colorize_options(add_spaces_to_options(update_rows))

    default_options = [false] * update_rows.length

    idx = Ask.checkbox(
      question,
      options,
      default: default_options
    )
    do_update(update_rows, idx)
  end

  def self.do_update(update_rows, idx)
    Bundler.ui = Bundler::UI::Shell.new
    Bundler.ui.level = "error"
    name = update_rows.map(&:name)
    up = name.delete_if { |x| !idx[name.index(x)] }
    Bundler::CLI::Update.new({},up).run
  end

  def self.add_spaces_to_options(update_rows)
    rows = update_rows.map(&:to_a)
    max_lengths = find_max_lengths(rows)

    formatted_rows = rows.map do |row|
      row.each_with_index.map do |val, index|
        spaces_to_add = ' ' * (max_lengths[index] - val.length)
        val + spaces_to_add
      end
    end
  end

  def self.colorize_options(rows)
    rows.map do |row|
      row.each_with_index.map do |val, index|
        if index == 0
          Paint[val, 'red']
        else
          val
        end
      end.join('  ')
    end
  end

  def self.find_max_lengths(rows)
    iter_length = 5
    max_lengths = []

    (0...iter_length).each do |column_index|
      max_length = 0

      (0...(rows.length)).each do |row_index|
        item = rows[row_index][column_index]
        max_length = [item.length, max_length].max
      end

      max_lengths << max_length
    end

    max_lengths
  end


  def self.add_gem(current_spec, active_spec, dependency)
    spec_version = "#{active_spec.version}#{active_spec.git_version}"
    current_version = "#{current_spec.version}#{current_spec.git_version}"

    if dependency && dependency.specific?
      dependency_version = dependency.requirement
    end

    GemUpdateRow.new(active_spec.name, current_version, spec_version, dependency_version)
  end

  def self.retrieve_active_spec(definition, current_spec)

    active_specs = definition.find_indexed_specs(current_spec)
    if !current_spec.version.prerelease? && active_specs.size > 1
      active_specs.delete_if { |b| b.respond_to?(:version) && b.version.prerelease? }
    end
    active_spec = active_specs.last

    active_spec
  end


  def self.check_for_deployment_mode
    if Bundler.settings[:frozen]
      raise ProductionError, "You are trying to check outdated gems in " \
          "deployment mode. Run `gemoutdate` elsewhere.\n" \
          "\nIf this is a development machine, remove the " \
          "#{Bundler.default_gemfile} freeze" \
          "\nby running `bundle install --no-deployment`."
    end
  end

end