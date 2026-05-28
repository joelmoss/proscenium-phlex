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
      assert_equal(["#{path}/css_module_helper.module.css"], Proscenium::Importer.imported.keys)
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

      assert_match(/class="grandfather_[a-z0-9]{8}_app-components-grandfather-module"/, @response)
    end
  end

  # Closes the production-observed loop: under Phlex 1.x, `Phlex::ATTRIBUTE_CACHE` short-circuits
  # `process_attributes` on the second render of the same `(attributes, class)` pair, so the
  # in-transformer `Importer.import` side-effect never fires. The `after_template` replay reads
  # paths captured via `Transformer#class_names`'s block API and re-imports them, so the layout
  # still emits a `<link>` for the module.
  context 'side-load survives Phlex attribute cache hits' do
    it 'side-loads the CSS module on a second render with identical attributes' do
      # Cold render warms `Phlex::ATTRIBUTE_CACHE` and populates the class-level path registry.
      render Components::SideLoadCssModuleFromAttributesView.new(:@base)
      cold_keys = Proscenium::Importer.imported.keys
      assert(cold_keys.any? do |k|
        k.to_s.end_with?('side_load_css_module_from_attributes_view.module.css')
      end, 'cold render should side-load the CSS module')

      # Mimic a fresh request: the per-request side-load registry resets, the process-wide
      # attribute cache and the class-level resolved-paths registry survive.
      Proscenium::Importer.reset

      render Components::SideLoadCssModuleFromAttributesView.new(:@base)

      assert_equal cold_keys, (Proscenium::Importer.imported || {}).keys,
                   'second render must side-load the exact same CSS module key as the cold ' \
                   'render even when Phlex returns the cached attribute string for the same ' \
                   '(attributes, class) pair'
    end
  end
end
