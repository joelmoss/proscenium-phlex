# frozen_string_literal: true

class Components::CssModuleHelper < Components::Base
  include Proscenium::Phlex::CssModules

  def view_template
    h1 class: css_module(:header) do
      'Hello'
    end
  end
end
