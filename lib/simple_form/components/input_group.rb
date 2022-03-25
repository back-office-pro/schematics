# frozen_string_literal: true

module SimpleForm
  module Components
    module InputGroup
      def prepend(_wrapper_options)
        template.tag.div(options[:prepend], class: 'input-group-text border-0 bg-light pe-1')
      end

      def append(_wrapper_options)
        template.tag.div(options[:append], class: 'input-group-text border-0 bg-light ps-1')
      end
    end
  end
end
