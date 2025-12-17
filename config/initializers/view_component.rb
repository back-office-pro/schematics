# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# TODO: remove when https://github.com/ViewComponent/view_component/issues/2448 is fixed
ActiveSupport.on_load(:view_component) do
  slim_handler_factory = Temple::Templates::Rails(
    Slim::Engine,
    register_as: :slim,
    generator: Temple::Generators::RailsOutputBuffer,
    disable_capture: true,
    streaming: true
  )
  ActionView::Template.register_template_handler(:slim, slim_handler_factory.new)
end
