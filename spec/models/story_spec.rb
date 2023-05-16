# == Schema Information
#
# Table name: stories
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sub_topic_id   :bigint           not null
#  stem           :text
#  processed      :boolean          default(FALSE)
#  invalid_json   :boolean          default(FALSE)
#  invalid_images :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe Story, type: :model do
  let(:story) { create(:story) }

  it { should belong_to(:sub_topic) }
  it { should have_many(:assignments) }
  it { should have_many(:feed_items).through(:assignments) }
  it { should have_one(:story_tag) }
  it { should have_one(:tag).through(:story_tag) }
  it { should have_many(:images) }
  it { should have_many(:imaginations).through(:images) }
  it { should have_one(:discussion) }

  context 'scopes' do
    describe '.viewable' do
      it 'returns only processed and valid stories' do
        invalid_story = create(:story, processed: false, invalid_json: true)
        valid_story = create(:story, processed: true, invalid_json: false, invalid_images: false)

        expect(Story.viewable).to include(valid_story)
        expect(Story.viewable).not_to include(invalid_story)
      end
    end

    describe '.unprocessed' do
      it 'returns only unprocessed stories' do
        processed_story = create(:story, processed: true)
        unprocessed_story = create(:story, processed: false)

        expect(Story.unprocessed).to include(unprocessed_story)
        expect(Story.unprocessed).not_to include(processed_story)
      end
    end

    describe '.processed' do
      it 'returns only processed stories' do
        processed_story = create(:story, processed: true)
        unprocessed_story = create(:story, processed: false)

        expect(Story.processed).to include(processed_story)
        expect(Story.processed).not_to include(unprocessed_story)
      end
    end

    describe '.without_images' do
      it 'returns stories with no images and valid json' do
        story_without_images = create(:story, invalid_images: false, invalid_json: false)
        create(:image, story: story_without_images) # This story should now have images

        story_with_no_images = create(:story, invalid_images: false, invalid_json: false)
        # Don't add any images to this story

        expect(Story.without_images).to include(story_with_no_images)
        expect(Story.without_images).not_to include(story_without_images)
      end
    end

    describe '.with_stem_and_valid_processed_images' do
      it 'returns stories with a stem, valid, and processed images' do
        story_with_valid_images = create(:story, processed: true, invalid_json: false)
        create_list(:image, 3, story: story_with_valid_images, processed: true, invalid_prompt: false, uploaded: true)

        story_with_invalid_images = create(:story, processed: true, invalid_json: false)
        create_list(:image, 3, story: story_with_invalid_images, processed: false, invalid_prompt: true, uploaded: false)

        expect(Story.with_stem_and_valid_processed_images).to include(story_with_valid_images)
        expect(Story.with_stem_and_valid_processed_images).not_to include(story_with_invalid_images)
      end
    end

    describe '.with_stem_and_valid_processed_images_no_discussions' do
      it 'returns stories with a stem, valid, and processed images, and no discussions' do
        story_with_valid_images_and_no_discussion = create(:story, processed: true, invalid_json: false)
        create_list(:image, 3, story: story_with_valid_images_and_no_discussion, processed: true, invalid_prompt: false,
                               uploaded: true)

        story_with_valid_images_and_discussion = create(:story, processed: true, invalid_json: false)
        create_list(:image, 3, story: story_with_valid_images_and_discussion, processed: true, invalid_prompt: false,
                               uploaded: true)
        create(:discussion, story: story_with_valid_images_and_discussion)

        expect(Story.with_stem_and_valid_processed_images_no_discussions).to include(story_with_valid_images_and_no_discussion)
        expect(Story.with_stem_and_valid_processed_images_no_discussions).not_to include(story_with_valid_images_and_discussion)
      end
    end
  end
end
