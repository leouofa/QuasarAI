# frozen_string_literal: true

class WrapperComponent < ViewComponent::Base
  def initialize(name, **arguments)
    defaults = Ui::Utilities.instance.defaults(component: name)
    settings = merge_defaults(defaults, arguments)

    @component = Ui::Component.new(settings)
  end

  private

  def merge_defaults(defaults, args)
    defaults.each do |default|
      name = default_name(default)
      value = default_value(default)
      args[name] = value unless args.key?(name)
    end

    args
  end

  def tag_arguments
    arguments = {}
    arguments[:class] = @component.css_class
    arguments[:id] = @component.id
    arguments[:data] = @component.data
    arguments[:style] = @component.style
    arguments[:alt] = @component.alt
    arguments[:title] = @component.title
    arguments[:method] = @component.method
    arguments[:action] = @component.action_attr
    arguments[:name] = @component.name_attr
    arguments[:value] = @component.value
    arguments[:rel] = @component.rel
    arguments[:type] = @component.type
    arguments[:rows] = @component.rows
    arguments[:placeholder] = @component.placeholder
    arguments[:step] = @component.step
    arguments[:disabled] = @component.disabled
    arguments
  end

  # retrieves the default name from a hash
  def default_name(default)
    default[0].to_sym
  end

  # retrieves the default value from a hash
  def default_value(default)
    default[1]
  end
end
