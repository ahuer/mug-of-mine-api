# frozen_string_literal: true
class HomeController < ApplicationController

  def upload
    begin
      cloundinary_image = Cloudinary::Uploader.upload(params[:img])
      scaled_image_url = cloundinary_image['secure_url'].sub('upload/','upload/c_limit,w_1600/')
      response = {
        url: cloundinary_image['secure_url'],
        publicId: cloundinary_image['public_id'],
        scaledImageUrl: scaled_image_url,
        uploadedImageHeight: cloundinary_image['height'],
        uploadedImageWidth: cloundinary_image['width']
      }
      render status: 200, json: response
    rescue
      render status: 500, json: { message: 'There was a problem loading your image' }
    end
  end

  def delete
    begin
      Cloudinary::Uploader.destroy(params[:publicId])
      render status: 200, json: { message: 'IMAGE DELETED' }
    rescue
      render status: 500, json: { message: 'There was a problem deleting your image' }
    end
  end

  private

  def image_params
    params.permit(:img)
  end

  def delete_params
    params.permit(:publicId)
  end
end
