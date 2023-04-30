# frozen_string_literal: true

module Cli
  class Pathfinder
    def initialize
      @paths = {
        icons: {
          src: '/app/frontend/icons'
        },
        regular_icons: {
          src: '/app/frontend/icons/regular'
        },
        critical_icons: {
          src: '/app/frontend/icons/critical'
        },
        processing_icons: {
          src: '/app/frontend/icons/processing'
        },
        compiled_icons: {
          src: '/app/frontend/icons/compiled'
        },
        admin_fonts: {
          src: '/app/frontend/stylesheets/admin/fonts'
        },
        regular_fonts: {
          src: '/app/frontend/stylesheets/client/fonts/regular'
        },
        critical_fonts: {
          src: '/app/frontend/stylesheets/client/fonts/critical'
        }
      }
    end

    def find(path:, with_root: false)
      current_path = @paths[path]

      if with_root
        # chop off the '/' from the path
        sliced_path = current_path[:src][1..]

        return Rails.root.join(sliced_path)
      end

      current_path[:src]
    end
  end
end
