# frozen_string_literal: true

class Views::Layouts::Inheritance < Views::Base
  include Proscenium::Phlex::Sideload

  def around_template
    doctype

    html do
      head do
        title { 'Hello' }
        include_assets
      end

      body { super }
    end
  end
end
