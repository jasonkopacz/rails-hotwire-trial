require "rails_helper"

RSpec.describe "Sessions" do
  let(:user) { create(:user, email: "alice@example.com", password: "password123") }

  describe "GET /login" do
    it "renders the sign-in page" do
      get login_path
      expect(response).to have_http_status(:ok)
    end

    it "redirects to photos if already signed in" do
      sign_in_as(user)
      get login_path
      expect(response).to redirect_to(photos_path)
    end
  end

  describe "POST /login" do
    context "with valid credentials" do
      it "signs in the user and redirects to photos" do
        post login_path, params: { email: user.email, password: "password123" }
        expect(response).to redirect_to(photos_path)
      end

      it "resets the session on login to prevent session fixation" do
        get login_path
        cookie_before = response.cookies["_photo_gallery_session"]

        post login_path, params: { email: user.email, password: "password123" }
        cookie_after = response.cookies["_photo_gallery_session"]

        expect(cookie_after).not_to eq(cookie_before)
      end
    end

    context "with invalid credentials" do
      it "re-renders the login page with 422" do
        post login_path, params: { email: user.email, password: "wrong" }
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "does not sign in the user" do
        post login_path, params: { email: user.email, password: "wrong" }
        get photos_path
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE /logout" do
    it "signs out the user and redirects to login" do
      sign_in_as(user)
      delete logout_path
      expect(response).to redirect_to(login_path)
    end

    it "clears the session so subsequent requests require login" do
      sign_in_as(user)
      delete logout_path
      get photos_path
      expect(response).to redirect_to(login_path)
    end
  end
end
