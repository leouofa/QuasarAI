# frozen_string_literal: true

require 'cli/pathfinder'
require 'cli/icons'

namespace :icons do
  desc 'Compiles all icons'
  task compile: :environment do
    icons = Cli::Icons.new
    icons.erase_all

    icons.compile_admin
    icons.cleanup

    icons.compile_regular
    icons.cleanup

    icons.compile_critical
    icons.cleanup
  end
end
