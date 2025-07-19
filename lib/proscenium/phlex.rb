# frozen_string_literal: true

require 'proscenium'
require 'proscenium/phlex/engine'
require 'phlex-rails'

module Proscenium
  module Phlex
    class Error < StandardError; end

    autoload :AbstractClass, 'proscenium/phlex/abstract_class'
    autoload :IncludeAssets, 'proscenium/phlex/include_assets'
    autoload :Sideload, 'proscenium/phlex/sideload'
    autoload :CssModules, 'proscenium/phlex/css_modules'
    autoload :CssModuleRewriter, 'proscenium/phlex/css_module_rewriter'
    autoload :React, 'proscenium/phlex/react'
  end
end
