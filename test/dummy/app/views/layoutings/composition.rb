# frozen_string_literal: true

module Views
  class Layoutings::Composition < Views::Base
    include Proscenium::Phlex::Sideload

    def view_template
      render Layouts::Application do
        h1 { 'Views::Layoutings::Composition' }
      end
    end
  end
end
