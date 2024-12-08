module Generators
  module Blueprints
    class BlueprintsGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_templates
        # Get all files in the source root
        files = Dir.glob("#{self.class.source_root}/**/*")

        files.each do |file|
          # Remove the source root from the file path
          relative_path = file.sub("#{self.class.source_root}/", '')

          # Copy file to destination directory
          copy_file relative_path, "blueprints/#{relative_path}"
        end
      end
    end
  end
end
