module StoryPro
  class CreateDiscussionJob < ApplicationJob
    queue_as :default


    def perform(story:)
      # Do something later
      user_id = story.sub_topic.storypro_user_id
      category_id =  story.sub_topic.storypro_category_id
      stem = JSON.parse(story.stem)

      images =  Image.where(story:)

      header_image, content_images = extract_header_and_content_images(images)


      name =  stem["title"]
      header_landscape_image_url, header_vertical_image_url = extract_image_urls(header_image)

      discussion = Publisher.new(kind: :discussion, name:, user_id:, category_id:)

      dropcap_shown = false

      discussion.areas do |area|
        area.populate_area 'header' do |element|
          element.add 'image-header',
                      'landscape_image': header_landscape_image_url,
                      'vertical_image': header_vertical_image_url,
                      'overlay_background': 'fixed'
        end

        area.populate_area 'content' do |element|
          stem['content'].each_with_index do |content, index|
            element.add 'heading', header: content['header'],
                        size: "#{index == 0 ? 'h1' : 'h3'}"

            content['paragraphs'].each do |paragraph|
              element.add 'rich-text', rich: "<p>#{paragraph}</p>",
                          dropcap: !dropcap_shown ? 'show' : 'hide',
                          dropcap_background_color: !dropcap_shown ? 'blue' : ''

              dropcap_shown = true
            end

            if content_images[index]
              landscape_image_url, vertical_image_url = extract_image_urls(content_images[index])

              element.add 'oversized-image',
                           'landscape_image': landscape_image_url,
                            'vertical_image': vertical_image_url,
                            'overlay_background': 'fixed'
            end

            element.add 'spacer', size: 'large' unless index == stem['content'].length - 1
            element.add 'divider' unless index == stem['content'].length - 1
            element.add 'spacer', size: 'large'unless index == stem['content'].length - 1
          end
        end

      end

      discussion.publish

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

      [landscape_url, vertical_url]
    end

  end
end
