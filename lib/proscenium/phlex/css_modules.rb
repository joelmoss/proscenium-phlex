# frozen_string_literal: true

require 'phlexible'

module Proscenium::Phlex
  module CssModules
    extend ActiveSupport::Concern

    included do
      include Proscenium::CssModule
      include Proscenium::SourcePath
      extend Proscenium::CssModule::Path
      extend Phlexible::ProcessAttributes
    end

    class_methods do
      # Set of CSS module paths that have been resolved after being transformed from 'class' HTML
      # attributes. See #process_attributes. This is here because Phlex caches attributes. Which
      # means while the CSS class names will be transformed, any resolved paths will be lost in
      # subsequent requests.
      attr_accessor :resolved_css_module_paths
    end

    def before_template
      self.class.resolved_css_module_paths ||= Concurrent::Set.new
      super
    end

    def after_template
      (self.class.resolved_css_module_paths ||= Concurrent::Set.new).each do |path|
        Proscenium::Importer.import path, sideloaded: true
      end

      super
    end

    # Resolve and side load any CSS modules in the "class" attributes, where a CSS module is a class
    # name beginning with a `@`. The class name is resolved to a CSS module name based on the file
    # system path of the Phlex class, and any CSS file is side loaded.
    #
    # For example, the following will side load the CSS module file at
    # app/components/user/component.module.css, and add the CSS Module name `user_name` to the
    # <div>.
    #
    #   # app/components/user/component.rb
    #   class User::Component < Proscenium::Phlex
    #     def view_template
    #       div class: :@user_name do
    #         'Joel Moss'
    #       end
    #     end
    #   end
    #
    # Additionally, any class name containing a `/` is resolved as a CSS module path. Allowing you
    # to use the same syntax as a CSS module, but without the need to manually import the CSS file.
    #
    # For example, the following will side load the CSS module file at /lib/users.module.css, and
    # add the CSS Module name `name` to the <div>.
    #
    #   class User::Component < Proscenium::Phlex
    #     def view_template
    #       div class: '/lib/users@name' do
    #         'Joel Moss'
    #       end
    #     end
    #   end
    #
    # @raise [Proscenium::CssModule::Resolver::NotFound] If a CSS module file is not found for the
    #   Phlex class file path.
    def process_attributes(attributes)
      if attributes.key?(:class) && (attributes[:class] = tokens(attributes[:class])).include?('@')
        names = attributes[:class].is_a?(Array) ? attributes[:class] : attributes[:class].split

        paths = self.class.resolved_css_module_paths ||= Concurrent::Set.new

        attributes[:class] = cssm.class_names(*names) do |_name, path|
          paths << path if path
        end
      end

      attributes
    end

    def tokens(*tokens, **conditional_tokens)
      conditional_tokens.each do |condition, token|
        truthy = case condition
                 when Symbol then send(condition)
                 when Proc then condition.call
                 else raise ArgumentError, 'The class condition must be a Symbol or a Proc.'
                 end

        if truthy
          case token
          when Hash then __append_token__(tokens, token[:then])
          else __append_token__(tokens, token)
          end
        else
          case token
          when Hash then __append_token__(tokens, token[:else])
          end
        end
      end

      tokens = tokens.select(&:itself).join(' ')
      tokens.strip!
      tokens.gsub!(/\s+/, ' ')
      tokens
    end

    private

      def __append_token__(tokens, token)
        case token
        when nil then nil
        when String then tokens << token
        when Symbol then tokens << token.name
        when Array then tokens.concat(token)
        else raise ArgumentError,
                   'Conditional classes must be Symbols, Strings, or Arrays of Symbols or Strings.'
        end
      end
  end
end
