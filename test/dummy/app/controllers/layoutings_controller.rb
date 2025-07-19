# frozen_string_literal: true

class LayoutingsController < ApplicationController
  layout false

  def composition
    render Views::Layoutings::Composition
  end

  def inheritance
    render Views::Layoutings::Inheritance
  end
end
