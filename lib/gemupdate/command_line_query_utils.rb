NAME_INDEX = 0

class CommandLineQueryUtils

  class << self

    def add_spaces_to_options(update_rows)
      rows = update_rows.map(&:to_a)
      max_lengths = find_max_lengths(rows)

      rows.map do |row|
        row.each_with_index.map do |val, index|
          spaces_to_add = ' ' * (max_lengths[index] - val.length)
          val + spaces_to_add
        end
      end
    end

    def colorize_options(rows)
      rows.map do |row|
        row.each_with_index.map do |val, index|
          if index == NAME_INDEX
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

  end
end