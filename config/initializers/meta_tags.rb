# frozen_string_literal: true

module MetaTags
  module ViewHelper
    # removing unused view helpers
    remove_method :title, :description
  end
end
