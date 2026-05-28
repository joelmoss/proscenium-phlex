# frozen_string_literal: true

# Register the CSS module rewriter hook before Rails eager-loads the app, so that
# components matching the include pattern are transformed when they're required.
Proscenium::Phlex::CssModuleRewriter.init(
  include: [
    Rails.root.join('app/components/css_module_rewriter/*.rb').to_s
  ]
)
