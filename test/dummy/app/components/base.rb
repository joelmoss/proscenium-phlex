# frozen_string_literal: true

class Components::Base < Phlex::HTML
  include Proscenium::Phlex::IncludeAssets

  self.abstract_class = true
end
