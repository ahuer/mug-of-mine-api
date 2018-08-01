# frozen_string_literal: true
require 'net/https'
require 'open-uri'
require 'json'

class HomeController < ApplicationController
  def wakeup
    render status: 200, json: { message: "I'm awake!" }
  end

  def upload
    render status: 200, json: { response: 'ok' }
  end

  private

  def image_params
    params.require(:img)
  end

end
