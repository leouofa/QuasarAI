# frozen_string_literal: true

module SettingsHelper
  # default accessor for settings proxy
  # @param [String] path a string path in dot notation
  # @param [Hash] options fetching options
  # @option options [Symbol] :fatal_exception raises fatal exception if set to true
  def settings(path, options = {})
    defaults = { fatal_exception: false }
    options = defaults.merge(options)

    SettingProxy.instance.fetch(path, options)
  end

  # Shortcut for settings with fatal exception enabled
  # @param [String] path a string path in dot notation
  def s(path)
    SettingProxy.instance.s(path)
  end

  # # returns the name of the setting node
  # def node_name(node)
  #   node[0].to_s
  # end
  #
  # # returns the value of the setting node
  # def node_value(node)
  #   node[1]
  # end
end
