# frozen_string_literal: true

class Components::React::ForwardChildren < Components::Base
  include Proscenium::Phlex::React
  self.forward_children = true
end
