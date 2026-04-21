class LikesController < ApplicationController
  before_action :set_photo, only: [:create]
  before_action :set_like,  only: [:destroy]

  def create
    current_user.likes.create_or_find_by(photo: @photo)
    @photo.likes.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to photos_path }
    end
  end

  def destroy
    @photo = @like.photo
    @like.destroy
    @photo.likes.reload
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to photos_path }
    end
  end

  private

  def set_photo
    @photo = Photo.includes(:likes).find(params[:photo_id])
  end

  def set_like
    @like = current_user.likes.includes(photo: :likes).find(params[:id])
  end
end
