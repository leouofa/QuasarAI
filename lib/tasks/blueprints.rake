require 'json'

namespace :blueprints do
  desc 'Updating blueprints'
  task update: :environment do
    topics_file = Rails.root.join('blueprints/topics.yml')
    topics = YAML.load(File.read(topics_file))["topics"]

    topics.each do |topic|
      current_topic = Topic.find_or_create_by name: topic["name"]
      topic["sub_topics"].each do |sub_topic|
        current_sub_topic_topic = SubTopic.find_or_create_by! name: sub_topic["name"],
                                                              topic_id: current_topic.id
        current_sub_topic_topic.update!(stream_id: sub_topic["stream_id"], min_tags_for_story: sub_topic["min_tags_for_story"])
      end
    end
  end
end
