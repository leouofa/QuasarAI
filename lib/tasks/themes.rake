# frozen_string_literal: true

require 'fileutils'

namespace :themes do
  # locations
  themes_src_loc = '/app/frontend/themes/src'
  themes_dist_loc = '/app/frontend/themes/dist'
  semantic_src_loc = '/app/frontend/semantic/src'
  semantic_dist_loc = '/app/frontend/semantic/dist'

  desc 'compile all themes'
  task compile_all: :environment do
    themes = Dir[Dir.pwd + themes_src_loc + '/*']
    themes.each do |theme|
      theme_name = theme.split('/').last

      theme_config = theme + '/theme.config'
      config_destination = Dir.pwd + semantic_src_loc + '/theme.config'

      copy_file theme_config, config_destination

      puts "Compiling #{theme_name}"
      `npx gulp build --gulpfile app/frontend/semantic/gulpfile.js`

      compiled_theme = Dir.pwd + semantic_dist_loc
      compiled_destination = "#{Dir.pwd}#{themes_dist_loc}/#{theme_name}"

      puts "Copying #{theme_name}"
      FileUtils.cp_r "#{compiled_theme}/.", compiled_destination
    end
  end

  desc 'compiles a theme'
  task compile: :environment do
    prompt = TTY::Prompt.new
    prompt.say '******* ------------------ *******', color: :on_white
    prompt.say '******* Theme Compiler 1.0 *******', color: :on_white
    prompt.say '******* ------------------ *******', color: :on_white

    theme_names = []
    Dir[Dir.pwd + themes_src_loc + '/*'].each do |theme|
      theme_names << theme.split('/').last
    end

    theme = prompt.select('Which theme would you like to compile?', theme_names)
    theme_folder = Dir[Dir.pwd + themes_src_loc + "/#{theme}"].last
    theme_config = theme_folder + '/theme.config'

    config_destination = Dir.pwd + semantic_src_loc + '/theme.config'
    copy_file theme_config, config_destination

    puts "Compiling #{theme}"
    `npx gulp build --gulpfile app/frontend/semantic/gulpfile.js`

    compiled_theme = Dir.pwd + semantic_dist_loc
    compiled_destination = "#{Dir.pwd}#{themes_dist_loc}/#{theme}"

    puts "Copying #{theme}"
    FileUtils.cp_r "#{compiled_theme}/.", compiled_destination
  end
end
