require 'bundler'
require 'inquirer'
require 'paint'

class GemUpdateRow
  attr_accessor :name, :locked_version, :available_version

  def initialize(name)
    @name = name
    @locked_version = "1.4.4"
    @available_version = "1.5.1"
  end

  def name_colored
    Paint[locked_version, "gold"]
  end

  def locked_version_colored
    Paint[locked_version, "white"]
  end

  def available_version_colored
    Paint[available_version, "white"]
  end

  def to_a
    [name.to_s, locked_version, '>', available_version]
  end

  # def to_a
    # [name_colored, locked_version_colored, available_version_colored]
  # end
end

class Gemupdate

  def self.run(gemfile_lock_path)

    unless File.exists?(gemfile_lock_path)
      puts "No Gemfile in that directory"
      return
    end

    lockfile_raw = Bundler.read_file(gemfile_lock_path)

    update_rows = parse_lockfile(lockfile_raw)[0..10]

    ask_user(update_rows)
  end

  def self.parse_lockfile(lockfile_raw)
    lockfile = Bundler::LockfileParser.new(lockfile_raw)

    lockfile.specs.map { |spec| GemUpdateRow.new(spec) }
  end

  def self.ask_user(update_rows)
    question = "Pick the gems you want to update... (space to select, enter to update selected)"
    options = add_spaces_to_options(update_rows)

    default_options = [false] * update_rows.length

    idx = Ask.checkbox(
      question,
      options,
      default: default_options
    )
  end

  def self.add_spaces_to_options(update_rows)
    rows = update_rows.map { |r| r.to_a }
    max_lengths = find_max_lengths(rows)

    formatted_rows = rows.map do |row|
      row.each_with_index.map do |val, index|
        spaces_to_add = ' ' * (max_lengths[index] - val.length)
        val + spaces_to_add
      end.join('  ')
    end
  end

  def self.find_max_lengths(rows)
    iter_length = 4
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
end