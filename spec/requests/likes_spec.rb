require "rails_helper"

RSpec.describe "Likes" do
  let(:user)  { create(:user) }
  let(:photo) { create(:photo) }

  describe "POST /photos/:photo_id/likes" do
    context "when not signed in" do
      it "redirects to login" do
        post photo_likes_path(photo)
        expect(response).to redirect_to(login_path)
      end
    end

    context "when signed in" do
      before { sign_in_as(user) }

      it "creates a like and responds with turbo stream" do
        post photo_likes_path(photo),
             headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response.body).to include("like-button-#{photo.id}")
      end

      it "increments the like count in the database" do
        expect {
          post photo_likes_path(photo),
               headers: { "Accept" => "text/vnd.turbo-stream.html" }
        }.to change(Like, :count).by(1)
      end

      it "is idempotent when already liked — does not create a duplicate" do
        create(:like, user: user, photo: photo)
        expect {
          post photo_likes_path(photo),
               headers: { "Accept" => "text/vnd.turbo-stream.html" }
        }.not_to change(Like, :count)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /likes/:id" do
    context "when not signed in" do
      it "redirects to login" do
        like = create(:like, user: user, photo: photo)
        delete like_path(like)
        expect(response).to redirect_to(login_path)
      end
    end

    context "when signed in" do
      before { sign_in_as(user) }

      it "destroys the like and responds with turbo stream" do
        like = create(:like, user: user, photo: photo)
        delete like_path(like),
               headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(Like.exists?(like.id)).to be false
      end

      it "cannot delete another user's like" do
        other_user = create(:user)
        other_like = create(:like, user: other_user, photo: photo)
        expect {
          delete like_path(other_like),
                 headers: { "Accept" => "text/vnd.turbo-stream.html" }
        }.not_to change(Like, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
