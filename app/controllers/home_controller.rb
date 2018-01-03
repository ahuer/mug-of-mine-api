# frozen_string_literal: true
class HomeController < ApplicationController

  def upload
    @msg = { sup: "dude" }
    render json: @msg
  end

end
