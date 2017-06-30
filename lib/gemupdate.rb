require 'bundler'
require 'bundler/cli'
require 'bundler/cli/update'

require 'inquirer'
require 'paint'

require_relative './gemupdate/outdated_gems.rb'
require_relative './gemupdate/gem_update_row.rb'
require_relative './gemupdate/command_line_query_utils.rb'

class Gemupdate

  class << self

    def run
      outdated_gems_list = OutdatedGems.make_list
      if outdated_gems_list.empty?
        up_to_date
        return
      end

      outdated_gems_to_update = ask_what_gems_to_update(outdated_gems_list)
      if outdated_gems_to_update.empty?
        no_gems_picked
        return
      end

      do_update(outdated_gems_to_update)
    end

    private

    def ask_what_gems_to_update(update_rows)
      gem_update_rows = update_rows.map { |spec| GemUpdateRow.from_gem_spec(spec) }
      options, default = GemUpdateRow.to_ask_options(gem_update_rows)

      indexes = Ask.checkbox(
        question,
        options,
        default: default
      )

      gem_names = update_rows.map(&:name)
      gem_names.select.with_index do |_gem_name, index|
        indexes[index]
      end
    end

    def do_update(gems_to_update)
      Bundler.ui = Bundler::UI::Shell.new
      Bundler.ui.level = 'error'
      Bundler::CLI::Update.new({}, gems_to_update).run
    end

    def up_to_date
      puts 'Bundle up to date!\n'
    end

    def no_gems_picked
      puts 'You should choose any gems to update!\n'
    end

    def question
      'Pick the gems you want to update... (space to select, enter to update selected)'
    end

  end
end