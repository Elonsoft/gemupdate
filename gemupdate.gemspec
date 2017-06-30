# coding: utf-8
# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name        = 'gemupdate'
  s.version     = '0.0.1'
  s.license     = 'MIT'
  s.authors     = [
    'Dmitry Kolupaev', 'Alexandra Terzieva'
  ]
  s.email       = ['dmitry.klpv@gmail.com']
  s.homepage    = 'https://github.com/Elonsoft/gemupdate'
  s.summary     = 'Interactive updater for gems'
  s.description = 'Gem updater with interactive command-line interface.'

  # if s.respond_to?(:metadata=)
    # s.metadata = {
      # "bug_tracker_uri" => "",
      # "changelog_uri" => "",
      # "homepage_uri" => "",
      # "source_code_uri" => "",
    # }
  # end

  # todo: revisit this later
  s.required_ruby_version = '>= 2.4.0'

  s.add_runtime_dependency 'bundler',  '~> 1.15'
  s.add_runtime_dependency 'inquirer', '~> 0.2'
  s.add_runtime_dependency 'paint',    '~> 2.0'

  s.bindir        = 'exe'
  s.executables   = %w[gemupdate]
  # s.require_paths = ['lib/gemupdate']
  s.files = %w(lib/gemupdate.rb lib/gemupdate/gem_update_row.rb lib/gemupdate/outdated_gems.rb lib/gemupdate/utils.rb)
end