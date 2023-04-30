# frozen_string_literal: true

require 'cli/pathfinder'

module Cli
  class Icons
    def initialize
      pathfiner = Cli::Pathfinder.new
      @regular = pathfiner.find(path: :regular_icons, with_root: true)
      @critical = pathfiner.find(path: :critical_icons, with_root: true)
      @processing = pathfiner.find(path: :processing_icons, with_root: true)
      @compiled = pathfiner.find(path: :compiled_icons, with_root: true)

      @admin_fonts = pathfiner.find(path: :admin_fonts, with_root: true)
      @regular_fonts = pathfiner.find(path: :regular_fonts, with_root: true)
      @critical_fonts = pathfiner.find(path: :critical_fonts, with_root: true)
    end

    attr_reader :icon_root, :regular, :critical, :processing, :compiled, :fonts

    def erase_all
      FileUtils.rm_rf("#{@processing}/.", secure: true)
      FileUtils.rm_rf("#{@compiled}/.", secure: true)
      FileUtils.rm_rf("#{@admin_fonts}/.", secure: true)
      FileUtils.rm_rf("#{@regular_fonts}/.", secure: true)
    end

    def cleanup
      FileUtils.rm_rf("#{@processing}/.", secure: true)
      FileUtils.rm_rf("#{@compiled}/.", secure: true)
    end

    # we do not distinguish between regular and critical for the admin.
    def compile_admin
      FileUtils.cp_r "#{@regular}/.", @processing
      FileUtils.cp_r "#{@critical}/.", @processing

      `npx fantasticon`

      replace_css(name: 'admin')
      rename_files(name: 'admin')
      FileUtils.cp_r "#{@compiled}/.", @admin_fonts
    end

    def compile_regular
      FileUtils.cp_r "#{@regular}/.", @processing

      `npx fantasticon`

      replace_css(name: 'regular')
      rename_files(name: 'regular')
      FileUtils.cp_r "#{@compiled}/.", @regular_fonts
    end

    def compile_critical
      FileUtils.cp_r "#{@critical}/.", @processing

      `npx fantasticon`

      replace_css(name: 'critical')
      rename_files(name: 'critical')
      FileUtils.cp_r "#{@compiled}/.", @critical_fonts
    end

    def replace_css(name:)
      css_file = "#{@compiled}/icon.css"
      css_text = File.read(css_file)
      replaced_css = css_text.gsub(/icon-\d+-/, '')

      replaced_css = replaced_css.gsub(/@@font@@/, name)

      replaced_css = replaced_css.gsub(/@@woff@@/, "#{name}.woff")
      replaced_css = replaced_css.gsub(/@@woff2@@/, "#{name}.woff2")

      File.open(css_file, 'w') { |file| file.puts replaced_css }
    end

    def rename_files(name:)
      Dir.glob("#{@compiled}/*").each do |entry|
        # we don't want to rename the css file
        next if entry.include?('css')

        # lets rename the icon flies with the new name
        new_filename = entry.gsub('icon.', "#{name}.")
        File.rename(entry, new_filename)
      end
    end
  end
end
