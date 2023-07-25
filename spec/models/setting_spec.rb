require 'rails_helper'

RSpec.describe Setting, type: :model do
  describe '#within_publish_window?' do
    let(:setting) { Setting.create! }

    context 'when current time is within publish time' do
      it 'returns true' do
        Timecop.freeze(Time.utc(2023, 7, 25, 10)) do
          setting.publish_start_time = Time.zone.parse('08:00')
          setting.publish_end_time = Time.zone.parse('21:00')
          setting.save!

          expect(setting.within_publish_window?).to be true
        end
      end
    end

    context 'when current time is outside publish time' do
      it 'returns false' do
        Timecop.freeze(Time.utc(2023, 7, 25, 5)) do
          setting.publish_start_time = Time.zone.parse('08:00')
          setting.publish_end_time = Time.zone.parse('21:00')
          setting.save!

          expect(setting.within_publish_window?).to be false
        end
      end
    end

    context 'when publish times wrap around midnight' do
      it 'returns true if current time is after start time' do
        Timecop.freeze(Time.utc(2023, 7, 25, 23)) do
          setting.publish_start_time = Time.zone.parse('22:00')
          setting.publish_end_time = Time.zone.parse('06:00')
          setting.save!

          expect(setting.within_publish_window?).to be true
        end
      end

      it 'returns true if current time is before end time' do
        Timecop.freeze(Time.utc(2023, 7, 26, 1)) do
          setting.publish_start_time = Time.zone.parse('22:00')
          setting.publish_end_time = Time.zone.parse('06:00')
          setting.save!

          expect(setting.within_publish_window?).to be true
        end
      end
    end
  end
end
