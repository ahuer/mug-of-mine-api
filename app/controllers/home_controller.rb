# frozen_string_literal: true

class HomeController < ApplicationController
  SHOPIFY_API_KEY = ENV['SHOPIFY_API_KEY']
  SHOPIFY_API_PASSWORD = ENV['SHOPIFY_API_PASSWORD']
  PRINTFUL_API_KEY = ENV['PRINTFUL_API_KEY']

  def upload
    cloudinary_image = img_upload(image_params)
    if cloudinary_image.present?
      scaled_image_url = cloudinary_image['secure_url'].sub('upload/','upload/c_limit,w_1600/')
      response = {
        url: cloudinary_image['secure_url'],
        publicId: cloudinary_image['public_id'],
        scaledImageUrl: scaled_image_url,
        uploadedImageHeight: cloudinary_image['height'],
        uploadedImageWidth: cloudinary_image['width']
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
    binding.pry
    cloudinary_image = img_upload(image_params)
    unless cloudinary_image.present?
      render status: 500, json: { message: 'There was a problem loading your image' }
      return
    end

    shopify_mug = create_shopify_mug(cloudinary_image['secure_url'])

    unless shopify_mug.present?
      render status: 500, json: { message: 'There was an issue adding the product to Shopify' }
      return
    end

    error_message = sync_printful_mug(shopify_mug, cloudinary_image)

    if error_message.present?
      render status: 500, json: { message: error_message }
      return
    end

    render status: 200, json: { shopifyVariantID: shopify_mug.variants.first.id }
    # shopify_checkout = create_shopify_checkout(shopify_mug)
    #
    # unless shopify_checkout.present?
    #   render status: 500, json: { message: 'There was an issue adding creating the Shopify checkout' }
    #   return
    # end
    #
    # render status: 200, json: { checkoutURL: shopify_checkout.web_url }
  end

  private

  def image_params
    params.require(:img)
  end

  def delete_params
    params.require(:publicId)
  end

  def mug_size_params
    params.permit(:mugSize)
  end

  def img_upload(img)
    begin
      Cloudinary::Uploader.upload(params[:img])
    rescue
      nil
    end
  end

  def connect_to_shopify
    shop_url = "https://#{SHOPIFY_API_KEY}:#{SHOPIFY_API_PASSWORD}@mug-of-mine.myshopify.com/admin"
    ShopifyAPI::Base.site = shop_url
  end

  def create_shopify_mug(image_url)
    connect_to_shopify

    begin
      product = ShopifyAPI::Product.new(shopify_mug_params(image_url))
      product.save
      product
    rescue
      nil
    end
  end

  def shopify_mug_params(image_url)
    if mug_size_params[:mugSize] == '11oz'
      size = '11oz'
      price = '19.30'
      grams = 369
      weight = 13
    else
      size = '15oz'
      price = '25.73'
      grams = 454
      weight = 16
    end

    {
      title: "Custom Mug - " + Time.now.utc.to_s,
      body_html: "Custom mug",
      product_type: "Mug",
      vendor: "Mug of Mine",
      published: false,
      variants: [
        {
          option1: size,
          price: price,
          fulfillment_service: "manual",
          taxable: true,
          grams: grams,
          weight: weight,
          weight_unit: "oz",
          requires_shipping: true
        }
      ],
      images: [
        {
          src: image_url
        }
      ]
    }
  end

  def printful_request_body(cloudinary_image)
    if mug_size_params[:mugSize] == '11oz'
      variant = 1320
    else
      variant = 4830
    end

    {
    	"variant_id": variant,
      "files": [
        {
          "url": cloudinary_image['secure_url']
        }
      ]
    }
  end

  def sync_printful_mug(shopify_mug, cloudinary_image)
    printful_client = PrintfulClient.new(PRINTFUL_API_KEY)
    begin
      pp printful_client.put("sync/variant/@#{shopify_mug.variants.first.id}",printful_request_body(cloudinary_image))
      nil
    rescue PrintfulApiException => e
        'There was a Printful sync API exception: %i %s' % [e.code, e.message]
    rescue PrintfulException => e
        'There was a Printful sync exception: ' + e.message
    end
  end

  def create_shopify_checkout(shopify_mug)
    begin
      checkout = ShopifyAPI::Checkout.new(shopify_checkout_params(shopify_mug.variants.first.id))
      checkout.save
      checkout
    rescue
      nil
    end
  end

  def shopify_checkout_params(variant_id)
    {
      line_items: [{ variant_id: variant_id, quantity: 1 }]
    }
  end
end
