# frozen_string_literal: true

# Returns the setting value based on the passed path
class SettingInterface
  attr_accessor :settings

  def initialize(settings)
    @settings = settings
  end

  # Returns the setting value based on the passed path.
  # @param path [String] the setting path separated by '.' notation.
  # @param options [Hash] options for the fetch operation.
  # @return [Object] the retreived settings value
  # @note if _options.fatal_exception_ is set to true then error will be thrown if the fragment is missing.

  def fetch_setting(path, options = {})
    # split the path into an array
    path_array = path.split('.')
    value = nil
    path_array.each_with_index do |fragment, index|
      value = @settings[fragment] if index.eql? 0
      value = value[fragment] unless index.eql? 0
      raise "fragment `#{fragment}` does not exist within `#{path}`" if value.nil? && options[:fatal_exception]
      return nil if value.nil?
    end
    value
  end
end
