# frozen_string_literal: true

module Views
  class Layoutings::Inheritance < Views::Layouts::Inheritance
    def view_template
      h1 { 'Views::Layoutings::Inheritance' }
    end
  end
end
