# frozen_string_literal: true
class HomeController < ApplicationController
  def index
    @msg = "hello bitch"
  end

  def checkout
    shopify_key = ENV['SHOPIFY_KEY'] || 'KeyNotFound'
    shopify_password = ENV['SHOPIFY_PASS'] || 'PasswordNotFound'
    binding.pry
  end
end
