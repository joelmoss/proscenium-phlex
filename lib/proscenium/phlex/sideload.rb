# frozen_string_literal: true

module Proscenium::Phlex
  module Sideload
    extend ActiveSupport::Concern
    include AbstractClass

    included do
      include Proscenium::SourcePath

      class_attribute :sideload_assets_options
    end

    class_methods do
      def sideload_assets(value)
        self.sideload_assets_options = value
      end
    end

    def before_template
      controller = (try(:view_context) || try(:helpers)).controller
      if controller.respond_to?(:sideload_assets_options)
        Proscenium::SideLoad.sideload_inheritance_chain self, controller.sideload_assets_options
      end

      super
    end
  end
end
