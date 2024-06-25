# spec/jobs/pillars/populate_pillars_job_spec.rb
require 'rails_helper'

RSpec.describe Pillars::PopulatePillarsJob, type: :job do
  include SettingsHelper

  let!(:setting) { create(:setting) }

  before do
    allow_any_instance_of(SettingsHelper).to receive(:s).with('pillars').and_return(setting.pillars)
  end

  it 'creates pillars based on the settings' do
    expect { described_class.perform_now }.to change { Pillar.count }.by(3)

    pillars = Pillar.all
    expect(pillars.map(&:title)).to match_array(%w[Business Gaming Music])
    expect(pillars.map(&:columns)).to all(eq(20))
  end
end
