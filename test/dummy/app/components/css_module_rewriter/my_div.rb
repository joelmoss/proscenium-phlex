# frozen_string_literal: true

class Components::CssModuleRewriter::MyDiv < Components::Base
  def initialize(**attrs)
    @attrs = attrs
  end

  def view_template(&)
    div(**@attrs, &)
  end
end
