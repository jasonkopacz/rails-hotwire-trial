require "rails_helper"

RSpec.describe "Photos" do
  let(:user) { create(:user) }

  describe "GET /photos" do
    context "when not signed in" do
      it "redirects to login" do
        get photos_path
        expect(response).to redirect_to(login_path)
      end
    end

    context "when signed in" do
      before { sign_in_as(user) }

      it "returns 200" do
        get photos_path
        expect(response).to have_http_status(:ok)
      end

      it "renders photos" do
        create_list(:photo, 3)
        get photos_path
        expect(response.body).to include("photo-card")
      end

      it "renders the like button in unliked state when user has not liked the photo" do
        create(:photo)
        get photos_path
        expect(response.body).to include('aria-label="Like photo"')
      end

      it "renders the like button in liked state when user has liked the photo" do
        photo = create(:photo)
        create(:like, user: user, photo: photo)
        get photos_path
        expect(response.body).to include('aria-label="Unlike photo"')
      end
    end
  end
end
