class OutdatedGems

  class << self

    def make_list
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
          groups = dependency.groups.join(', ')
        end

        outdated_gems_list << { active_spec: active_spec,
                                current_spec: current_spec,
                                dependency: dependency,
                                groups: groups }
      end

      outdated_gems_list
    end

    private

    def retrieve_active_spec(definition, current_spec)
      active_specs = definition.find_indexed_specs(current_spec)
      if !current_spec.version.prerelease? && active_specs.size > 1
        active_specs.delete_if { |b| b.respond_to?(:version) && b.version.prerelease? }
      end
      active_spec = active_specs.last

      active_spec
    end

  end

end