# frozen_string_literal: true

module Components::CssModuleRewriter
  class ClassCssModule < Base
    def view_template
      my_div(class: :@title) { 'Hello' }
    end
  end
end
