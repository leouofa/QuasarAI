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
        current_sub_topic_topic.update!(stream_id: sub_topic["stream_id"])
      end
    end

    # Dir.foreach(Rails.root.join('blueprints')) do |blueprint|
    #   next if blueprint == '.' || blueprint == '..'
    #
    #   # Load Blueprint Settings
    #   blueprint_settings = YAML.load(File.read(File.expand_path(Rails.root.join("blueprints/#{blueprint}"), __FILE__)))
    #
    #   # Update Blueprint Record
    #   blueprint_record = Blueprint.find_or_create_by name: blueprint.gsub('.yml', '')
    #   blueprint_record.settings = JSON.parse(blueprint_settings.to_json)
    #   blueprint_record.save
    # end
  end
end
