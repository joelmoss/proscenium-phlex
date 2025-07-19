# frozen_string_literal: true

module Components::CssModuleRewriter
  class NonCssModule < Base
    def view_template
      my_div(class: :title) { 'Hello' }
    end
  end
end
