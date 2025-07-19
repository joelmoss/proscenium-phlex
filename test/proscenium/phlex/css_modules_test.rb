# frozen_string_literal: true

require 'test_helper'

class Proscenium::Phlex::CssModulesTest < ActiveSupport::TestCase
  describe 'class attribute' do
    context 'plain class name' do
      it 'should not use css module name' do
        render Components::SideLoadCssModuleFromAttributesView.new('base')

        assert_dom 'div.base', text: 'Hello'
      end
    end

    context 'css module class name' do
      it 'should use css module name' do
        render Components::SideLoadCssModuleFromAttributesView.new(:@base)

        assert_dom 'div.base-2ea1c733', text: 'Hello'
      end
    end
  end

  context 'css_module helper' do
    it 'replaces with CSS module name' do
      fragment = render_fragment Components::CssModuleHelper.new

      assert_equal '<h1 class="header-7d8d692a">Hello</h1>', fragment
    end

    it 'side loads css module' do
      render Components::CssModuleHelper.new

      path = '/node_modules/@rubygems/proscenium-phlex/test/dummy/app/components'
      assert_equal({
                     "#{path}/css_module_helper.module.css" => {
                       digest: '7d8d692a'
                     }
                   }, Proscenium::Importer.imported)
    end
  end

  describe 'css_module_path' do
    it 'child inherits parent if child does not exist' do
      father = Components::Father.css_module_path
      child = Components::Child.css_module_path

      assert_equal father, child
    end
  end

  context 'child and parent css module path' do
    it 'uses child' do
      render Components::Father.new

      assert_dom 'h1.grandfather-61c6900a', text: 'Grandfather'
    end
  end

  context 'parent and no child css module path' do
    it 'uses parent' do
      render Components::Child.new

      assert_dom 'h1.grandfather-61c6900a', text: 'Grandfather'
    end
  end

  context 'child and no parent css module path' do
    it 'uses parent' do
      render Components::Grandfather.new

      assert_dom 'h1.grandfather-699e297c', text: 'Grandfather'
    end
  end
end
