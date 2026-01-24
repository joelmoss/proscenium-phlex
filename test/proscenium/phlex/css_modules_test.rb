# frozen_string_literal: true

require 'test_helper'

class Proscenium::Phlex::CssModulesTest < ActiveSupport::TestCase
  describe 'class attribute' do
    context 'plain class name' do
      it 'should not use css module name' do
        render Components::SideLoadCssModuleFromAttributesView.new('base')

        assert_equal '<div class="base">Hello</div>', @response
      end
    end

    context 'css module class name' do
      it 'should use css module name' do
        render Components::SideLoadCssModuleFromAttributesView.new(:@base)

        assert_match(
          /class="base_[a-z0-9]{8}_app-components-side_load_css_module_from_attributes_view-module"/, # rubocop:disable Layout/LineLength
          @response
        )
      end
    end
  end

  context 'css_module helper' do
    it 'replaces with CSS module name' do
      render Components::CssModuleHelper.new

      assert_match(
        /class="header_[a-z0-9]{8}_app-components-css_module_helper-module"/,
        @response
      )
    end

    it 'side loads css module' do
      render Components::CssModuleHelper.new

      path = '/node_modules/@rubygems/proscenium-phlex/test/dummy/app/components'
      assert_equal({
                     "#{path}/css_module_helper.module.css" => {
                       digest: '39452110'
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

      assert_match(/class="grandfather_[a-z0-9]{8}_app-components-father-module"/, @response)
    end
  end

  context 'parent and no child css module path' do
    it 'uses parent' do
      render Components::Child.new

      assert_match(/class="grandfather_[a-z0-9]{8}_app-components-father-module"/, @response)
    end
  end

  context 'child and no parent css module path' do
    it 'uses parent' do
      render Components::Grandfather.new

      assert_dom 'h1.grandfather_c538d4aa_app-components-grandfather-module', text: 'Grandfather'
    end
  end
end
