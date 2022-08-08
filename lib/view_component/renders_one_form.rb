# frozen_string_literal: true

# https://github.com/github/view_component/pull/240#issuecomment-950159559
# TODO: Remove when https://github.com/github/view_component/pull/974 is merged

module ViewComponent
  module RendersOneForm
    extend ActiveSupport::Concern

    class_methods do
      def renders_one_form(name)
        attr_reader name

        define_method(:render_in) do |view_context, &block|
          old_form_view_context = public_send(name).instance_variable_get(:@template)
          public_send(name).instance_variable_set(:@template, self)
          super(view_context, &block)
        ensure
          public_send(name).instance_variable_set(:@template, old_form_view_context)
        end
      end
    end
  end
end
