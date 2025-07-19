# frozen_string_literal: true

class Components::One < Components::Base
  include Proscenium::Phlex::Sideload

  def view_template
    h1 { 'hello' }
  end
end
