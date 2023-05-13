# frozen_string_literal: true

# Class acting as a proxy between Setting and SiteSettings
class SettingProxy
  include Singleton

  def initialize; end

  # shortcut for accessing regular settings
  # @param [String] path string path in dot notation
  def s(path)
    fetch(path, fatal_exception: true)
  end

  # delegates setting requests between settings and site settings
  # @param [String] path a string path in dot notation
  # @param [Hash] params fetching options
  # @option params [Symbol] :fatal_exception raises fatal exception if set to true
  def fetch(path, params = {})
    path_array = path.split('.')

    fetch_settings path_array.join('.'), params
  end

  # fetches settings value
  # @param [String] path a string path in dot notation
  # @param [Hash] options fetching options
  # @option params [Symbol] :fatal_exception raises fatal exception if set to true
  def fetch_settings(path, options = {})
    settings ||= SettingInterface.new(Settings)
    settings.fetch_setting(path, options)
  end
end
