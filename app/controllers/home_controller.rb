# frozen_string_literal: true
class HomeController < ApplicationController
  def index
    @msg = "hello bitch"
  end

  def checkout
    connect_to_shopify
    shop = ShopifyAPI::Shop.current
    product = ShopifyAPI::Product.find(18308235266)
    variant_id = product.variants.first.id
    redirect_to create_shopify_checkout(variant_id)
  end

  private

  def connect_to_shopify
    shopify_key = ENV['SHOPIFY_KEY'] || 'KeyNotFound'
    shopify_password = ENV['SHOPIFY_PASS'] || 'PasswordNotFound'
    shop_name = 'mug-of-mine'

    shop_url = "https://#{shopify_key}:#{shopify_password}@#{shop_name}.myshopify.com/admin"
    ShopifyAPI::Base.site = shop_url
  end

  def create_shopify_checkout(variant_id)
    checkout = ShopifyAPI::Checkout.new(populate_params(variant_id))
    binding.pry
    checkout.save
    checkout.web_url
  end

  def populate_params(variant_id)
    {
      line_items: [{ variant_id: variant_id, quantity: 1 }]
    }
  end
end
