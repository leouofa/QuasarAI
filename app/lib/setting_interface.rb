# frozen_string_literal: true

# Returns the setting value based on the passed path
class SettingInterface
  attr_accessor :settings

  def initialize(settings)
    @settings = settings
  end

  def reload_settings
    db_settings = Setting.instance
    @settings.add_source!(YAML.load(db_settings.topics)) if db_settings.topics.present?
    @settings.add_source!(YAML.load(db_settings.prompts)) if db_settings.prompts.present?
    @settings.add_source!(YAML.load(db_settings.tunings)) if db_settings.tunings.present?
    @settings.add_source!(YAML.load(db_settings.pillars)) if db_settings.pillars.present?
    @settings.reload!
  end

  # Returns the setting value based on the passed path.
  # @param path [String] the setting path separated by '.' notation.
  # @param options [Hash] options for the fetch operation.
  # @return [Object] the retrieved settings value
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
