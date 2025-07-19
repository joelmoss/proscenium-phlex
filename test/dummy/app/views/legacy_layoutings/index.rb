# frozen_string_literal: true

module Views
  class LegacyLayoutings::Index < Views::Base
    include Proscenium::Phlex::Sideload

    def view_template
      h1 { 'Views::LegacyLayoutings::Index' }
    end
  end
end
