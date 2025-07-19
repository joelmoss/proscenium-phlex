# frozen_string_literal: true

class Components::Nested < Components::Base
  include Proscenium::Phlex::Sideload

  def view_template
    h1 { 'hello' }
    One()
  end
end
