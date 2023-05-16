module StoryPro
  class CreateDiscussionJob < ApplicationJob
    queue_as :default


    def perform(discussion:)
      story = discussion.story

      user_id = story.sub_topic.storypro_user_id
      category_id =  story.sub_topic.storypro_category_id
      stem = JSON.parse(discussion.stem)

      images =  Image.where(story:)

      header_image, content_images = extract_header_and_content_images(images)

      name =  stem["title"]
      description = stem['summary'].truncate(150)

      tag = story.tag.name
      story_pro_tags = StoryPro.get_tags

      if story_pro_tags.empty?
        tag_rsp = StoryPro.create_tag(name: tag)
        tag = tag_rsp["id"]
      else
        find_tag = story_pro_tags.find { |t| t["name"] == tag }

        if find_tag
          tag = find_tag["id"]
        else
          tag_rsp = StoryPro.create_tag(name: tag)
          tag = tag_rsp["id"]
        end
      end

      story_pro_categories = StoryPro.get_categories
      found_story_pro_category = story_pro_categories.find { |c| c["id"] == category_id }

      colors = StoryPro.get_colors
      found_color = colors['colors'].find { |c| c["id"] == found_story_pro_category["id"] }

      header_landscape_image_url, header_vertical_image_url, card_image_url = extract_image_urls(header_image)

      regular_css_elements = StoryPro.get_elements(type: 'elements_regularcss')
      fullscreen_css_elements = StoryPro.get_elements(type: 'elements_fullscreencss')

      new_discussion = Publisher.new(kind: :discussion, name:, user_id:, category_id:)

      # - The `tag` update is not working right now.
      # - The will need be re-implemented to call the `tagging` endpoint.
      # - The `tagging` endpoint needs to first be created on the platform.
      new_discussion.update(description:, social_image: card_image_url, tags: [tag])

      dropcap_shown = false

      begin
        new_discussion.areas do |area|
          area.populate_area 'header' do |element|
            element.add 'image-header',
                        'landscape_image': header_landscape_image_url,
                        'vertical_image': header_vertical_image_url,
                        'overlay_background': 'fixed',
                        title: name,
                        title_alignment: weighted_sample(fullscreen_header_alignment),
                        header_animation: weighted_sample(fullscreen_header_animation),
                        text_animation: weighted_sample(fullscreen_header_text_animation),
                        geometry: weighted_sample(fullscreen_header_geometry),
                        filter: weighted_sample(fullscreen_header_filter),
                        elements_fullscreencss_id: search_elements_by_name(fullscreen_css_elements,
                                                                           'IMAGEHEADER')

          end

          area.populate_area 'content' do |element|
            stem['content'].each_with_index do |content, index|

              if index == 4
                element.add 'colorblock', title: content['header'],
                            color: found_color['name'],
                            title_alignment: weighted_sample(fullscreen_header_alignment),
                            header_animation: weighted_sample(fullscreen_header_animation),
                            text_animation: weighted_sample(fullscreen_header_text_animation),
                            geometry: weighted_sample(fullscreen_header_geometry),
                            filter: weighted_sample(fullscreen_header_filter)
              else
                element.add 'heading', header: content['header'],
                            size: "#{index == 0 ? 'h1' : 'h2'}",
                            transition: rand < 0.3 ? 'opacity-1' : '',
                            elements_regularcss_id: search_elements_by_name(regular_css_elements,
                                                                            'HEADING', 50)

              end


              content['paragraphs'].each_with_index do |paragraph, paragraph_index|
                element.add 'richtext', rich: "<p>#{paragraph}</p>",
                            dropcap: !dropcap_shown ? 'show' : 'hide',
                            dropcap_background_color: !dropcap_shown ?  found_color['name'] : '',
                            transition: weighted_sample(richtext_transitions),
                            elements_regularcss_id: search_elements_by_name(regular_css_elements,
                                                                            'RICHTEXT')
                dropcap_shown = true

                if paragraph_index == 2 and content['paragraphs'].count > 3 and (index == 2 || index == 3 ||index == 4 || index == 7)
                  element.add 'spacer', size: 'large'
                  element.add 'divider', elements_regularcss_id: search_elements_by_name(regular_css_elements,
                                                                              'DIVIDER')
                end
              end

              if content_images[index]
                landscape_image_url, vertical_image_url, _card_image_url = extract_image_urls(content_images[index])

                element.add 'oversized-image',
                              landscape_image: landscape_image_url,
                              vertical_image: vertical_image_url,
                              overlay_background: weighted_sample(fullscreen_header_overlay_background),
                              geometry: weighted_sample(fullscreen_header_geometry),
                              filter: weighted_sample(fullscreen_header_filter)
              end
            end
          end

          area.populate_area 'reference' do |element|
            story.feed_items.each do |feed_item|
              element.add 'reference',
                          title: feed_item.title.present? ? feed_item.title : feed_item.url,
                          link: feed_item.url,
                          author: feed_item.author.present? ? feed_item.author : feed_item.url,
                          source: feed_item.author.present? ? feed_item.author : feed_item.url,
                          date: feed_item.published.strftime('%B %d, %Y')
            end

          end


          publish_rsp = new_discussion.publish

          if publish_rsp.is_a?(Hash) && publish_rsp['errors'].present?
            raise "Error publishing discussion: #{publish_rsp['errors']}"
          end

          discussion.update(uploaded: true, published_at: Time.now.utc, story_pro_id: publish_rsp['id'])
        end

      rescue => e
        delete_and_log_error(discussion, e)
      end
    end

    def extract_header_and_content_images(images)
      header_image = images[0]
      content_images = images[1..-1]
      [header_image, content_images]
    end

    def extract_image_urls(image)
      landscape_uuid = image.landscape_imagination.uploadcare.last['uuid']
      landscape_url = "https://ucarecdn.com/#{landscape_uuid}/"

      vertical_uuid = image.portrait_imagination.uploadcare.last['uuid']
      vertical_url = "https://ucarecdn.com/#{vertical_uuid}/"

      card_uuid = image.card_imagination.uploadcare.last['uuid']
      card_url = "https://ucarecdn.com/#{card_uuid}/"

      [landscape_url, vertical_url, card_url]
    end

    def delete_and_log_error(discussion, error)
      Rails.logger.debug error
      Rails.logger.debug discussion.inspect
      attempts = 0

      begin
        discussion.delete
      rescue => e
        attempts += 1
        retry if attempts < 3
      end
    end

    def search_elements_by_name(elements, search_term, percentage = nil)
      element_hashes = elements.select do |e|
        fields = e['element']['fields']
        name = fields['name']
        name && name.include?(search_term)
      end

      if element_hashes.empty?
        return ''
      end

      chosen_element_hash = element_hashes.sample
      id = chosen_element_hash['element']['id']

      if percentage
        # rand(100) returns a number between 0 and 99. Adding 1 to get a number between 1 and 100.
        rand_val = rand(100) + 1
        return rand_val <= percentage ? id : ''
      else
        return id
      end
    end

    def weighted_sample(transitions)
      weighted_transitions = transitions.flat_map { |transition, weight| [transition] * weight }
      weighted_transitions.sample
    end

    def richtext_transitions
      [
        ['', 2],
        ['opacity-1', 1],
      ]
    end

    def fullscreen_header_alignment
      [
        ['left', 2],
        ['centered', 1],
        ['right', 1],
        ['justified', 1],
      ]
    end

    def fullscreen_header_animation
      [
        ['none', 2],
        ['blink', 1],
        ['flip', 1],
        ['flip-2', 1],
        ['flip-3', 1],
        ['pulse', 1],
        ['pulse-2', 1],
        ['pulse-3', 1],
        ['shake', 1],
        ['shake-2', 1],
        ['shake-3', 1],
        ['shake-4', 1],
        ['shake-5', 1]
      ]
    end

    def fullscreen_header_geometry
      [
        ['none', 1],
        ['bevel', 1],
        ['circle', 1],
        ['hexagon', 1],
        ['left arrow', 1],
        ['parallelogram left', 1],
        ['parallelogram right', 1],
        ['pentagon', 1],
        ['rabbet', 1],
        ['rectangle', 1],
        ['right arrow', 1],
        ['triangle bottom', 1],
        ['triangle top', 1]
      ]
    end

    def fullscreen_header_filter
      [
        ['none', 1],
        ['blur', 1],
        ['brightness', 1],
        ['brightness-2', 1],
        ['contrast', 1],
        ['contrast-2', 1],
        ['desaturate', 1],
        ['desaturate-saturate', 1],
        ['grayscale', 1],
        ['hue', 1],
        ['hue-blur', 1],
        ['hue-blur-desaturate', 1],
        ['hue-blur-desaturate-saturate', 1],
        ['hue-blur-saturate', 1],
        ['hue-desaturate', 1],
        ['hue-desaturate-saturate', 1],
        ['hue-desaturate-saturate-2', 1],
        ['hue-desaturate-saturate-3', 1],
        ['hue-saturate', 1],
        ['invert', 1],
        ['saturate', 1],
        ['sepia', 1]
      ]
    end

    def fullscreen_header_text_animation
      [
        ['none', 2],
        ['blink', 1],
        ['flip', 1],
        ['flip-2', 1],
        ['flip-3', 1],
        ['pulse', 1],
        ['pulse-2', 1],
        ['pulse-3', 1],
        ['shake', 1],
        ['shake-2', 1],
        ['shake-3', 1],
        ['shake-4', 1],
        ['shake-5', 1]
      ]
    end

    def fullscreen_header_overlay_background
      [
        ['normal', 1],
        ['fixed', 1]
      ]
    end
  end
end
