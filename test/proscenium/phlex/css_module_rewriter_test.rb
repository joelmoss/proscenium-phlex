# frozen_string_literal: true

require 'test_helper'

class Proscenium::Phlex::CssModuleRewriterTest < ActiveSupport::TestCase
  context 'with superclass css module path' do
    it 'rewrites class name beginning with @' do
      rewrite 'single_class'
      render Components::CssModuleRewriter::SingleClass
      assert_dom 'div.title_415a1d9e_app-components-css_module_rewriter-base-module', text: 'Hello'
    end

    it 'rewrites multiple class names beginning with @' do
      rewrite 'multiple_classes'
      render Components::CssModuleRewriter::MultipleClasses

      assert_dom 'div.title_415a1d9e_app-components-css_module_rewriter-base-module.another_class',
                 text: 'Hello'
    end

    it 'does not rewrite class names without with @' do
      rewrite 'non_css_module'
      render Components::CssModuleRewriter::NonCssModule

      assert_dom 'div.title', text: 'Hello'
    end
  end

  it 'uses class css module path' do
    rewrite 'class_css_module'
    render Components::CssModuleRewriter::ClassCssModule

    assert_dom 'div.title_7881b9e8_app-components-css_module_rewriter-class_css_module-module',
               text: 'Hello'
  end

  it 'uses custom css_module_path' do
    rewrite 'css_module_path'
    render Components::CssModuleRewriter::CssModulePath

    assert_dom 'div.title_7881b9e8_app-components-css_module_rewriter-class_css_module-module',
               text: 'Hello'
  end

  private

    def rewrite(filename)
      Proscenium::Phlex::CssModuleRewriter.init(
        include: [
          Rails.root.join('app/components/css_module_rewriter').to_s + "/#{filename}.rb"
        ]
      )
    end
end
