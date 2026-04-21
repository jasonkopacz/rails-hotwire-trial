require "rails_helper"

RSpec.describe Like do
  subject(:like) { build(:like) }

  it "is valid with valid attributes" do
    expect(like).to be_valid
  end

  describe "associations" do
    it "belongs to a user" do
      expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    end

    it "belongs to a photo" do
      expect(described_class.reflect_on_association(:photo).macro).to eq(:belongs_to)
    end
  end

  describe "presence validations" do
    it "is invalid without a user" do
      like = build(:like, user: nil)
      expect(like).not_to be_valid
    end

    it "is invalid without a photo" do
      like = build(:like, photo: nil)
      expect(like).not_to be_valid
    end
  end

  describe "uniqueness constraint" do
    let(:user)  { create(:user) }
    let(:photo) { create(:photo) }

    it "prevents a user from liking the same photo twice (model validation)" do
      create(:like, user: user, photo: photo)
      duplicate = build(:like, user: user, photo: photo)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to be_present
    end

    it "prevents a user from liking the same photo twice (database constraint)" do
      create(:like, user: user, photo: photo)
      expect {
        Like.connection.execute(
          "INSERT INTO likes (user_id, photo_id, created_at, updated_at) " \
          "VALUES (#{user.id}, #{photo.id}, datetime('now'), datetime('now'))"
        )
      }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "allows different users to like the same photo" do
      user2 = create(:user)
      create(:like, user: user, photo: photo)
      expect(build(:like, user: user2, photo: photo)).to be_valid
    end
  end
end
