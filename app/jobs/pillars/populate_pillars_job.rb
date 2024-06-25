class Pillars::PopulatePillarsJob < ApplicationJob
  queue_as :default
  include SettingsHelper

  def perform(*_args)
    pillars = s('pillars')

    pillars.each do |pillar_data|
      Pillar.find_or_create_by(title: pillar_data['name']) do |pillar|
        pillar.columns = pillar_data['columns']
      end
    end
  end
end
