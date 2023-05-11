module StoryPro
  class CreateDiscussionJob < ApplicationJob
    queue_as :default

    def perform(*args)
      # Do something later
      name = 'Test Test Discussion'
      user_id = 1
      category_id = 1

      discussion = Publisher.new(kind: :discussion, name:, user_id:, category_id:)

      discussion.areas do |area|
        area.populate_area 'header' do |element|
          element.add 'heading', header: "Hello Worldz"
        end
        area.populate_area 'content' do |element|
          element.add 'rich-text', rich: "Hello <b>World</b>"
          element.add 'divider', icon: 'none'
          element.add 'divider'
          element.add 'color_block'
          element.add 'heading', header: 'Hello World22'
          element.add 'rich-text', rich: "Hello <b>World</b>"
        end
      end

      discussion.publish

    end
  end
end
