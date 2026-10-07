# frozen_string_literal: true

class Views::Layouts::Application < Views::Base
  include Proscenium::Phlex::Sideload

  def view_template(&)
    doctype

    html do
      head do
        title { @title }
        include_assets
      end

      body(&)
    end
  end
end
