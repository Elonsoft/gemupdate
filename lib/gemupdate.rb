require 'bundler'

class Gemupdate

  def self.run(gemfile_lock_path)

    unless File.exists?(gemfile_lock_path)
      puts "No Gemfile in that directory"
      return
    end

    lockfile_raw = Bundler.read_file(gemfile_lock_path)
    parse_lockfile(lockfile_raw)
  end

  def self.parse_lockfile(lockfile_raw)
    lockfile = Bundler::LockfileParser.new(lockfile_raw)

    lockfile.specs.each do |s|
      puts "Spec: #{s}"
    end
  end
end