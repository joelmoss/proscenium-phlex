# frozen_string_literal: true

require 'test_helper'

class Proscenium::Phlex::IncludeAssetsTest < ActionDispatch::IntegrationTest
  describe '#include_assets' do
    test 'layout composition' do
      get '/layoutings/composition'

      # NOTE: unlike other layouting, each component is sideloaded independently of each other, so
      # CSS assets cannot be reversed. Meaning the order of the CSS files is not guaranteed.
      assert_dom 'link[rel="stylesheet"]', 2 do
        assert_dom_equal <<-HTML, it
          <link rel="stylesheet" href="#{VIEWS_PATH}/layoutings/composition.css"/>
          <link rel="stylesheet" href="#{VIEWS_PATH}/layouts/application.css"/>
        HTML
      end
      assert_dom 'script', 2 do
        assert_dom_equal <<-HTML, it
          <script src="#{VIEWS_PATH}/layoutings/composition.js"></script>
          <script src="#{VIEWS_PATH}/layouts/application.js"></script>
        HTML
      end
    end

    test 'layout inheritance' do
      get '/layoutings/inheritance'

      assert_dom 'link[rel="stylesheet"]', 2 do
        assert_dom_equal <<-HTML, it
          <link rel="stylesheet" href="#{VIEWS_PATH}/layouts/inheritance.css"/>
          <link rel="stylesheet" href="#{VIEWS_PATH}/layoutings/inheritance.css"/>
        HTML
      end
      assert_dom 'script', 2 do
        assert_dom_equal <<-HTML, it
          <script src="#{VIEWS_PATH}/layoutings/inheritance.js"></script>
          <script src="#{VIEWS_PATH}/layouts/inheritance.js"></script>
        HTML
      end
    end

    test 'legacy layouts' do
      get '/legacy_layoutings'

      assert_dom 'link[rel="stylesheet"]', 2 do
        assert_dom_equal <<-HTML, it
          <link rel="stylesheet" href="#{VIEWS_PATH}/legacy_layoutings/index.css"/>
          <link rel="stylesheet" href="#{VIEWS_PATH}/layouts/legacy.css"/>
        HTML
      end
      assert_dom 'script', 2 do
        assert_dom_equal <<-HTML, it
          <script src="#{VIEWS_PATH}/legacy_layoutings/index.js"></script>
          <script src="#{VIEWS_PATH}/layouts/legacy.js"></script>
        HTML
      end
    end
  end
end
