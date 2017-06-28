require 'bundler'

module Gemupdate

  def run
    lockfile = Bundler::LockfileParser.new(Bundler.read_file("Gemfile.lock"))

    lockfile.specs.each do |s|
      puts "Spec: #{s}"
    end
  end
end