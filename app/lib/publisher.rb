require 'story_pro'

class Publisher
  attr_accessor :kind, :name, :user_id, :category_id, :entry

  def initialize(kind:, name:, user_id:, category_id:)
    self.kind = kind
    self.name = name
    self.user_id = user_id
    self.category_id = category_id

    @entry = create_entry
    @areas = {}
  end

  def areas
    yield self
  end

  def populate_area(area_name)
    @areas[area_name] = []
    yield AreaElementBuilder.new(self, area_name)
  end

  def add_element_to_area(area_name, element_name, options)
    parent_id = @entry['id']
    parent_component = 'discussions'
    element = StoryPro.add_element(element: element_name, parent_id:, parent_component:,
                                   area: area_name)
    @areas[area_name] << element

    element_id = element['id']
    StoryPro.update_element(element_id, element: element_name, **options) unless options.empty?
    sleep(2)
  end

  def create_entry
    case kind
    when :discussion
      StoryPro.create_discussion(name:, user_id:, category_id:)
    when :article
      StoryPro.create_article(name:, user_id:, category_id:)
    when :video
      StoryPro.create_video(name:, user_id:, category_id:)
    when :promotion
      StoryPro.create_promotion(name:, user_id:, category_id:)
    else
      raise ArgumentError, "Invalid kind: '#{kind}'"
    end
  end

  def publish
    case kind
    when :discussion
      StoryPro.update_discussion(@entry['id'], published_date: Date.today.strftime("%B %d, %Y"))
    when :article
      StoryPro.update_article(@entry['id'], published_date: Date.today.strftime("%B %d, %Y"))
    when :video
      StoryPro.update_video(@entry['id'], published_date: Date.today.strftime("%B %d, %Y"))
    when :promotion
      StoryPro.update_promotion(@entry['id'], published_date: Date.today.strftime("%B %d, %Y"))
    else
      raise ArgumentError, "Invalid kind: '#{kind}'"
    end
  end

  def update(**options)
    case kind
    when :discussion
      StoryPro.update_discussion(@entry['id'], **options)
    when :article
      StoryPro.update_article(@entry['id'], **options)
    when :video
      StoryPro.update_video(@entry['id'], **options)
    when :promotion
      StoryPro.update_promotion(@entry['id'], **options)
    else
      raise ArgumentError, "Invalid kind: '#{kind}'"
    end
  end

  def delete
    case kind
    when :discussion
      StoryPro.delete_discussion(@entry['id'])
    when :article
      StoryPro.delete_article(@entry['id'])
    when :video
      StoryPro.delete_video(@entry['id'])
    when :promotion
      StoryPro.delete_promotion(@entry['id'])
    else
      raise ArgumentError, "Invalid kind: '#{kind}'"
    end

    Rails.logger.debug "Deleted entry: #{@entry}"
  end

  class AreaElementBuilder
    def initialize(publisher, area_name)
      @publisher = publisher
      @area_name = area_name
    end

    def add(element_name, options = {})
      allowed_element_names = %w[
        heading
        divider
        richtext
        embed
        image
        oversizedembed
        oversizedimage
        video
        blockquote
        oversizedquote
        reference
        solidheader
        imageheader
        embededheader
        videoheader
        colorblock
        featuredcontent
        discussion
        pagecss
        fullscreencss
        regularcss
        featuredcss
        spacer
        wall
      ]

      #  this allows us to pass both `elements_colorblock`, `colorblock`,
      # 'color_block', and 'color-block' as valid element_name
      has_elements_prefix = element_name.start_with?('elements_')
      element_name_without_prefix = element_name.gsub('elements_', '').gsub('_', '').gsub('-', '')

      if allowed_element_names.include?(element_name_without_prefix)
        compiled_element_name = "elements_#{element_name_without_prefix}"
        @publisher.add_element_to_area(@area_name, compiled_element_name, options)
      else
        display_element_names = allowed_element_names.map do |name|
          has_elements_prefix ? "elements_#{name}" : name
        end.join(', ')

        raise ArgumentError, "Invalid element_name: '#{element_name}'. Allowed values are: #{display_element_names}"
      end
    end
  end
end
