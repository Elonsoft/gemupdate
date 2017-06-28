require 'bundler'

class Gemupdate

  def self.run(gemfile_lock_path)
    lockfile = Bundler::LockfileParser.new(Bundler.read_file(gemfile_lock_path))

    lockfile.specs.each do |s|
      puts "Spec: #{s}"
    end
  end
end