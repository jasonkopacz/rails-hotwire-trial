require "rails_helper"

RSpec.describe Photo do
  subject(:photo) { build(:photo) }

  it "is valid with valid attributes" do
    expect(photo).to be_valid
  end

  describe "validations" do
    it "requires external_id" do
      photo.external_id = nil
      expect(photo).not_to be_valid
    end

    it "requires unique external_id" do
      create(:photo, external_id: "abc123")
      photo.external_id = "abc123"
      expect(photo).not_to be_valid
    end

    it "requires photographer" do
      photo.photographer = nil
      expect(photo).not_to be_valid
    end

    it "requires src_medium" do
      photo.src_medium = nil
      expect(photo).not_to be_valid
    end

    it "requires src_medium to be an http/https URL" do
      photo.src_medium = "javascript:alert(1)"
      expect(photo).not_to be_valid
    end

    it "requires source_url to be an http/https URL when present" do
      photo.source_url = "javascript:alert(1)"
      expect(photo).not_to be_valid
    end

    it "allows blank source_url" do
      photo.source_url = nil
      expect(photo).to be_valid
    end

    it "requires photographer_url to be an http/https URL when present" do
      photo.photographer_url = "data:text/html,<h1>XSS</h1>"
      expect(photo).not_to be_valid
    end

    it "allows blank photographer_url" do
      photo.photographer_url = nil
      expect(photo).to be_valid
    end
  end

  describe "#liked_by?" do
    let(:photo) { create(:photo) }
    let(:user)  { create(:user) }

    it "returns false when the user has not liked the photo" do
      photo.likes.load
      expect(photo.liked_by?(user)).to be false
    end

    it "returns true when the user has liked the photo" do
      create(:like, user: user, photo: photo)
      photo.likes.reload
      expect(photo.liked_by?(user)).to be true
    end

    it "returns false for nil user" do
      expect(photo.liked_by?(nil)).to be false
    end
  end

  describe "associations" do
    it "has many likes, destroyed with photo" do
      assoc = described_class.reflect_on_association(:likes)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:dependent]).to eq(:destroy)
    end

    it "has many liking_users through likes" do
      assoc = described_class.reflect_on_association(:liking_users)
      expect(assoc.macro).to eq(:has_many)
      expect(assoc.options[:through]).to eq(:likes)
    end
  end
end
