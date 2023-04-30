# frozen_string_literal: true

# adding r as an alias to the render method
# to make rendering our ui components easier on the eyes
raise "Cant monkeypatch ActionView::Helpers::RenderingHelper" unless defined?(ActionView::Helpers::RenderingHelper)

module ActionView
  module Helpers
    module RenderingHelper
      alias r render
    end
  end
end
