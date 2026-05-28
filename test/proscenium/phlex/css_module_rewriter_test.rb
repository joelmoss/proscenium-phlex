# frozen_string_literal: true

require 'test_helper'

class Proscenium::Phlex::CssModuleRewriterTest < ActiveSupport::TestCase
  before do
    Proscenium::Phlex::CssModuleRewriter.init(
      include: [
        Rails.root.join('app/components/css_module_rewriter/*.rb').to_s
      ]
    )
  end

  context 'with superclass css module path' do
    it 'rewrites class name beginning with @' do
      render Components::CssModuleRewriter::SingleClass

      assert_match(
        /class="title_[a-z0-9]{8}"/,
        @response
      )
    end

    it 'rewrites multiple class names beginning with @' do
      render Components::CssModuleRewriter::MultipleClasses

      assert_match(
        /class="title_[a-z0-9]{8}.another_class"/,
        @response
      )
    end

    it 'does not rewrite class names without with @' do
      render Components::CssModuleRewriter::NonCssModule

      assert_dom 'div.title', text: 'Hello'
    end
  end

  it 'uses class css module path' do
    render Components::CssModuleRewriter::ClassCssModule

    assert_match(
      /class="title_[a-z0-9]{8}"/,
      @response
    )
  end

  it 'uses custom css_module_path' do
    render Components::CssModuleRewriter::CssModulePath

    assert_match(
      /class="title_[a-z0-9]{8}"/,
      @response
    )
  end
end
