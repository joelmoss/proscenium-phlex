# frozen_string_literal: true

module Components::CssModuleRewriter
  class MultipleClasses < Base
    def view_template
      my_div('class' => %i[@title another_class]) { 'Hello' }
    end
  end
end
