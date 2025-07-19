# frozen_string_literal: true

module Components::CssModuleRewriter
  class Base < Components::Base
    include Proscenium::Phlex::CssModules

    def my_div(**attrs, &)
      render MyDiv.new(**attrs, &)
    end
  end
end
