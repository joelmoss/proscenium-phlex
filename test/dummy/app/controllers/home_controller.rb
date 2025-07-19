# frozen_string_literal: true

class HomeController < ApplicationController
  layout false

  def index
    render Views::Home::Index
  end
end
