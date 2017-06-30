require 'bundler'
require 'inquirer'
require 'bundler/cli'
require 'bundler/cli/update'

require_relative './gemupdate/outdated_gems.rb'
require_relative './gemupdate/utils.rb'

class Gemupdate

  def self.run
    @ut = Utils.new

    outdated_gems_list = OutdatedGems.new.make_list

    if outdated_gems_list.empty?
      puts 'Bundle up to date!\n'
    else
      specs = []
      outdated_gems_list.each do |gem|
        specs << @ut.add_gem(
            gem[:current_spec],
            gem[:active_spec],
            gem[:dependency]
        )
      end
      ask_user(specs)
      exit 1
    end
  end

  private

  def self.ask_user(update_rows)
    question = "Pick the gems you want to update... (space to select, enter to update selected)"
    options = @ut.colorize_options(@ut.add_spaces_to_options(update_rows))

    default_options = [false] * update_rows.length

    idx = Ask.checkbox(
      question,
      options,
      default: default_options
    )
    do_update(update_rows, idx)
  end

  def self.do_update(update_rows, idx)
    if idx.any?
      Bundler.ui = Bundler::UI::Shell.new
      Bundler.ui.level = "error"
      name = update_rows.map(&:name)
      up = name.delete_if {|x| !idx[name.index(x)]}
      Bundler::CLI::Update.new({}, up).run
    else
      puts "You should choose any gems to update!\n"
    end
  end


end