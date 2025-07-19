# frozen_string_literal: true

class Views::Layouts::Application < Views::Base
  include Proscenium::Phlex::Sideload

  def view_template(&block)
    doctype

    html do
      head do
        title { @title }
        include_assets
      end

      body(&block)
    end
  end
end
