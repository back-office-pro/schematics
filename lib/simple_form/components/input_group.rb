# frozen_string_literal: true

module SimpleForm
  module Components
    module InputGroup
      def append(_wrapper_options)
        template.tag.div(options[:append], class: 'input-group-text border-0 ps-1')
      end

      def prepend(_wrapper_options)
        template.tag.div(options[:prepend], class: 'input-group-text border-0 pe-1')
      end
    end
  end
end
