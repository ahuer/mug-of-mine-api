# frozen_string_literal: true
require  'pp'

class HomeController < ApplicationController

  def upload
    cloundinary_image = img_upload(image_params)
    if cloundinary_image.present?
      scaled_image_url = cloundinary_image['secure_url'].sub('upload/','upload/c_limit,w_1600/')
      response = {
        url: cloundinary_image['secure_url'],
        publicId: cloundinary_image['public_id'],
        scaledImageUrl: scaled_image_url,
        uploadedImageHeight: cloundinary_image['height'],
        uploadedImageWidth: cloundinary_image['width']
      }
      render status: 200, json: response
    else
      render status: 500, json: { message: 'There was a problem loading your image' }
    end
  end

  def delete
    begin
      Cloudinary::Uploader.destroy(delete_params)
      render status: 200, json: { message: 'IMAGE DELETED' }
    rescue
      render status: 500, json: { message: 'There was a problem deleting your image' }
    end
  end

  def submit
    cloundinary_image = img_upload(image_params)
    unless cloundinary_image.present?
      render status: 500, json: { message: 'There was a problem loading your image' }
      return
    end

    printful_client = PrintfulClient.new(ENV['PRINTFUL_API_KEY'])

    begin
      printful_response = pp printful_client.post('orders', printful_request_body(user_params, cloundinary_image))
      render status: 200, json: { orderInfo: printful_response }
    rescue PrintfulApiException => e
        printful_message = 'There was a Printful API exception: %i %s' % [e.code, e.message]
        render status: 500, json: { message: printful_message }
    rescue PrintfulException => e
        printful_message = 'There was a Printful exception: ' + e.message
        render status: 500, json: { message: printful_message }
    end
  end

  private

  def image_params
    params.permit(:img)
  end

  def delete_params
    params.permit(:publicId)
  end

  def user_params
    params.require(:info).permit(:name, :address, :city, :state, :country, :zip, :mugSize)
  end

  def img_upload(img)
    begin
      Cloudinary::Uploader.upload(params[:img])
    rescue
      nil
    end
  end

  def printful_request_body(user_params, cloundinary_image)
    mugSizeVariant = if user_params[:mugSize].present? && user_params[:mugSize] == '11oz'
      1320
    else
      4830
    end

    {
      "recipient": {
        "name": user_params[:name],
        "address1": user_params[:address],
        "city": user_params[:city],
        "state_code": user_params[:state],
        "country_code": user_params[:country],
        "zip": user_params[:zip]
      },
      "items": [{
        "variant_id": mugSizeVariant,
        "quantity": 1,
        "files": [{
          "url": cloundinary_image['secure_url']
        }]
      }]
    }
  end
end
