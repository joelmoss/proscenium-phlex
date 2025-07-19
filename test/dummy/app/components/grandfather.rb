# frozen_string_literal: true

class Components::Grandfather < Components::Base
  include Proscenium::Phlex::CssModules

  def view_template
    h1(class: :@grandfather) { 'Grandfather' }
  end
end
