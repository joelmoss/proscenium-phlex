# frozen_string_literal: true

module Proscenium::Phlex
  module AbstractClass
    extend ActiveSupport::Concern

    class_methods do
      attr_accessor :abstract_class
    end
  end
end
