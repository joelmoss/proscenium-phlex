# frozen_string_literal: true

require 'test_helper'

class Proscenium::Phlex::CssModuleRewriterTest < ActiveSupport::TestCase
  context 'with superclass css module path' do
    it 'rewrites class name beginning with @' do
      rewrite 'single_class'
      render Components::CssModuleRewriter::SingleClass

      assert_match(
        /class="title_[a-z0-9]{8}_app-components-css_module_rewriter-base-module"/,
        @response
      )
    end

    it 'rewrites multiple class names beginning with @' do
      rewrite 'multiple_classes'
      render Components::CssModuleRewriter::MultipleClasses

      assert_match(
        /class="title_[a-z0-9]{8}_app-components-css_module_rewriter-base-module.another_class"/,
        @response
      )
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

    assert_match(
      /class="title_[a-z0-9]{8}_app-components-css_module_rewriter-class_css_module-module"/,
      @response
    )
  end

  it 'uses custom css_module_path' do
    rewrite 'css_module_path'
    render Components::CssModuleRewriter::CssModulePath

    assert_match(
      /class="title_[a-z0-9]{8}_app-components-css_module_rewriter-class_css_module-module"/,
      @response
    )
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
