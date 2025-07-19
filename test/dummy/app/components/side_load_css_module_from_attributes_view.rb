# frozen_string_literal: true

class Components::SideLoadCssModuleFromAttributesView < Components::Base
  include Proscenium::Phlex::CssModules

  def initialize(class_name)
    @class_name = class_name
  end

  def view_template
    div(class: @class_name) { 'Hello' }
  end
end
