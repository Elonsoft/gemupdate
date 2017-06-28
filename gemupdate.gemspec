# coding: utf-8
# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name        = "bundler"
  s.version     = Bundler::VERSION
  s.license     = "MIT"
  s.authors     = [
    "Dmitry Kolupaev", "Vladimir Evseev"
  ]
  s.email       = ["dmitry.klpv@gmail.com"]
  s.homepage    = ""
  s.summary     = "Interactive updater for gems"
  s.description = "Gem updater with interactive command-line interface."

  # if s.respond_to?(:metadata=)
    # s.metadata = {
      # "bug_tracker_uri" => "",
      # "changelog_uri" => "",
      # "homepage_uri" => "",
      # "source_code_uri" => "",
    # }
  # end

  # todo: revisit this later
  s.required_ruby_version     = ">= 2.4.0"

  s.add_development_dependency "bundler", "~> 1.0.0"

  s.bindir        = "exe"
  s.executables   = %w[gemupdate gemup]
  s.require_paths = ["lib"]
end