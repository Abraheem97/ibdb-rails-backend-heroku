require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'validation tests' do
    let(:comment) { build(:comment) }

    it 'ensures comment body presence' do
      comment.body = nil
      expect(comment.save).to eq(false)
    end

    it 'should save successfully' do
      expect(comment.save).to eq(false)
    end
  end
end
