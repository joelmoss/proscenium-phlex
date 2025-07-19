# frozen_string_literal: true

require 'test_helper'

class Proscenium::Phlex::SideloadTest < ActionDispatch::IntegrationTest
  test 'sideloads component' do
    render Components::One.new

    assert_equal([
                   "#{COMPONENTS_PATH}/one.js",
                   "#{COMPONENTS_PATH}/one.css"
                 ], Proscenium::Importer.imported.keys)
  end

  test 'nested sideloading' do
    render Components::Nested.new

    assert_equal([
                   "#{COMPONENTS_PATH}/nested.js",
                   "#{COMPONENTS_PATH}/nested.css",
                   "#{COMPONENTS_PATH}/one.js",
                   "#{COMPONENTS_PATH}/one.css"
                 ], Proscenium::Importer.imported.keys)
  end

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
