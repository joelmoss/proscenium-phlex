# frozen_string_literal: true

module Views
  class Home::Index < Views::Base
    include Proscenium::Phlex::Sideload

    def view_template
      render Layouts::Application do
        h1 { 'Views::Home::Index' }
      end
    end
  end
end
