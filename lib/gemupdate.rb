require 'bundler'
require 'inquirer'
require 'paint'

require_relative './gemupdate/gem_update_row.rb'

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
    options = colorize_options(add_spaces_to_options(update_rows))

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