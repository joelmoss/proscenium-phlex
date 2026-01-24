# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require_relative '../test/dummy/config/environment'
require 'rails/test_help'
require 'minitest/difftastic'
require 'maxitest/autorun'

module ActionDispatch
  class IntegrationTest
    # FIXME: path should be relative to dummy app
    ROOT_PATH = '/node_modules/@rubygems/proscenium-phlex/test/dummy'
    COMPONENTS_PATH = "#{ROOT_PATH}/app/components".freeze
    VIEWS_PATH = "#{ROOT_PATH}/app/views".freeze
  end
end

module ActiveSupport
  class TestCase
    include Rails::Dom::Testing::Assertions

    # FIXME: path should be relative to dummy app
    ROOT_PATH = '/node_modules/@rubygems/proscenium-phlex/test/dummy'
    COMPONENTS_PATH = "#{ROOT_PATH}/app/components".freeze

    before do
      Proscenium.config.side_load = true
      Proscenium::Importer.reset
      Proscenium::Resolver.reset
    end

    private

      def render(...)
        @response = view_context.render(...)
      end

      def html_document
        @html_document ||= Rails::Dom::Testing.html_document.parse(@response)
      end

      def document_root_element
        html_document.try(:root) || html_document
      end

      def render_fragment(...)
        @response = render(...)
        @html_document = Rails::Dom::Testing.html_document_fragment.parse(@response)
        @response
      end

      delegate :view_context, to: :controller

      def controller
        @controller ||= ActionView::TestCase::TestController.new
      end
  end
end
