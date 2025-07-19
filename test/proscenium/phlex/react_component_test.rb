# frozen_string_literal: true

require 'test_helper'

class Proscenium::Phlex::ReactComponentTest < ActiveSupport::TestCase
  # describe 'system' do
  #   include_context SystemTest

  #   it 'renders with react' do
  #     visit '/phlex/react/one'
  #     pp page.console_logs

  #     expect(page.has_button?('Click One!')).to be == true
  #   end
  # end

  let(:selector) do
    "[data-proscenium-component-path='#{COMPONENTS_PATH}/react.jsx']"
  end

  it 'has data-proscenium-component attribute' do
    render Components::React.new

    assert_dom selector
  end

  it 'forwards block to content' do
    render(Components::React.new) { 'Hello' }

    assert_dom selector, text: 'Hello'
  end

  it 'has empty props' do
    render Components::React.new

    assert_dom_equal <<-HTML, html_document
      <div data-proscenium-component-path="#{COMPONENTS_PATH}/react.jsx"
           data-proscenium-component-props="{}"/>
    HTML
  end

  context 'props' do
    it 'should pass through props' do
      render Components::React.new(props: { name: 'Joel' })

      assert_dom_equal <<-HTML, html_document
        <div data-proscenium-component-path="#{COMPONENTS_PATH}/react.jsx"
             data-proscenium-component-props="{&quot;name&quot;:&quot;Joel&quot;}"/>
      HTML
    end

    it 'should camelCase props keys' do
      render Components::React.new(props: { first_name: 'Joel', 'some/last_name': 'Moss' })

      assert_dom_equal <<-HTML, html_document
        <div data-proscenium-component-path="#{COMPONENTS_PATH}/react.jsx"
             data-proscenium-component-props="{&quot;firstName&quot;:&quot;Joel&quot;,&quot;some/lastName&quot;:&quot;Moss&quot;}"/>
      HTML
    end
  end

  context 'root_tag' do
    after do
      Components::React.root_tag = :div # reset
    end

    it 'should use the given tag' do
      Components::React.root_tag = :span
      render Components::React.new

      assert_dom selector, tag: 'span'
    end
  end

  it 'should import component manager' do
    render Components::React.new

    assert_equal({
                   js: { type: 'module' }
                 }, Proscenium::Importer.imported['/proscenium/react-manager/index.jsx'])
  end

  describe 'lazy loading' do
    after do
      Components::React.lazy = false # reset
    end

    it 'should import component with `lazy: true` option' do
      skip 'TODO'
      render Components::React.new(lazy: true)

      assert Proscenium::Importer.imported['/app/components/phlex/basic_react_component.jsx'][:lazy]
    end

    context '`.lazy = true`' do
      it 'adds lazy data attribute' do
        Components::React.lazy = true
        render Components::React.new

        assert_dom "#{selector}[data-proscenium-component-lazy]"
      end
    end

    context '`.lazy = true` + `#lazy = false`' do
      it 'does not add lazy data attribute' do
        Components::React.lazy = true
        render Components::React.new(lazy: false)

        assert_not_dom "#{selector}[data-proscenium-component-lazy]"
      end
    end

    context '`.lazy = false` (default) + `#lazy = true`' do
      it 'adds lazy data attribute' do
        render Components::React.new(lazy: true)

        assert_dom "#{selector}[data-proscenium-component-lazy]"
      end
    end

    # describe 'system' do
    #   include_context SystemTest

    #   it 'renders when intersecting' do
    #     visit '/phlex/react/lazy'

    #     expect(page.has_button?('Click One!', wait: false)).to be == false

    #     page.driver.scroll_to(0, 2000)

    #     expect(page.has_button?('Click One!')).to be == true
    #   end
    # end
  end

  context '`.forward_children = true`' do
    after do
      Components::React::ForwardChildren.forward_children = true
    end

    let(:selector) do
      "[data-proscenium-component-path='#{COMPONENTS_PATH}/react/forward_children.jsx']"
    end

    it 'adds forward-children data attribute' do
      render(Components::React::ForwardChildren.new) { 'Hello' }

      assert_dom "#{selector}[data-proscenium-component-forward-children]"
    end

    it 'renders content block as children' do
      render(Components::React::ForwardChildren.new) { 'Hello' }

      assert_dom selector, text: 'Hello'
    end

    # context 'system' do
    #   include_context SystemTest

    #   it 'forwards block in children prop' do
    #     visit '/phlex/react/forward_children'

    #     expect(page.has_button?('hello')).to be == true
    #   end
    # end
  end

  context '`.forward_children = false`' do
    before do
      Components::React::ForwardChildren.forward_children = false
    end

    after do
      Components::React::ForwardChildren.forward_children = true
    end

    let(:selector) do
      "[data-proscenium-component-path='#{COMPONENTS_PATH}/react/forward_children.jsx']"
    end

    it 'does not adds forward-children data attribute' do
      render(Components::React::ForwardChildren.new) { 'Hello' }

      assert_not_dom "#{selector}[data-proscenium-component-forward-children]"
    end

    it 'renders content block as children' do
      render(Components::React::ForwardChildren.new) { 'Hello' }

      assert_dom selector, text: 'Hello'
    end

    # context 'system' do
    #   include_context SystemTest

    #   it 'does not forward block in children prop' do
    #     visit '/phlex/react/forward_children'

    #     expect(page.has_button?('Click One!')).to be == true
    #   end
    # end
  end
end
