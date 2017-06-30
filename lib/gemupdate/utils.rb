require 'paint'

require_relative './gem_update_row.rb'

class Utils

  def add_spaces_to_options(update_rows)
    rows = update_rows.map(&:to_a)
    max_lengths = find_max_lengths(rows)

    formatted_rows = rows.map do |row|
      row.each_with_index.map do |val, index|
        spaces_to_add = ' ' * (max_lengths[index] - val.length)
        val + spaces_to_add
      end
    end
  end

  def colorize_options(rows)
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

  def find_max_lengths(rows)
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


  def add_gem(current_spec, active_spec, dependency)
    spec_version = "#{active_spec.version}#{active_spec.git_version}"
    current_version = "#{current_spec.version}#{current_spec.git_version}"

    if dependency && dependency.specific?
      dependency_version = dependency.requirement
    end

    GemUpdateRow.new(active_spec.name, current_version,
                     spec_version, dependency_version)
  end
end