# frozen_string_literal: true

class LegacyLayoutingsController < ApplicationController
  layout -> { Views::Layouts::Legacy }

  def index
    render Views::LegacyLayoutings::Index
  end
end
