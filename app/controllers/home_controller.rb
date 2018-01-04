# frozen_string_literal: true
class HomeController < ApplicationController

  def upload
    test = Cloudinary::Uploader.upload(params[:img])
    @msg = { sup: "dude" }
    render json: @msg
  end

  private

  def image_params
    params.permit(:img)
  end
end
