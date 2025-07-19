# frozen_string_literal: true

class Views::Layouts::Legacy < Views::Base
  include Phlex::Rails::Layout
  include Proscenium::Phlex::Sideload

  def view_template(&block)
    doctype

    html do
      head do
        title { 'Hello' }
        include_assets
      end

      body(&block)
    end
  end
end
