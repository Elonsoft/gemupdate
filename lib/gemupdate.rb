require 'bundler'
require 'inquirer'

class Spec
  attr_accessor :locked_version

  def initialize(locked_version)
    @locked_version = locked_version
  end
end

class Gemupdate

  def self.run(gemfile_lock_path)

    unless File.exists?(gemfile_lock_path)
      puts "No Gemfile in that directory"
      return
    end

    lockfile_raw = Bundler.read_file(gemfile_lock_path)

    specs = parse_lockfile(lockfile_raw)

    ask_user(specs)
  end

  def self.parse_lockfile(lockfile_raw)
    lockfile = Bundler::LockfileParser.new(lockfile_raw)

    lockfile.specs.map { |spec| Spec.new(spec) }
  end

  def self.ask_user(specs)
    idx = Ask.checkbox(
      "Pick the gems you want to update...",
      specs.map { |s| s.locked_version },
      default: [false] * specs.length)

    puts "Selections #{idx}"
  end
end