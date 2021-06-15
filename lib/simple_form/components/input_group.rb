# frozen_string_literal: true

module SimpleForm
  module Components
    module InputGroup
      def prepend(_wrapper_options)
        span_tag = tag.span(options[:prepend], class: 'input-group-text border-0 pr-0')
        template.tag.div(span_tag, class: 'input-group-prepend')
      end

      def append(_wrapper_options)
        span_tag = tag.span(options[:append], class: 'input-group-text border-0 pl-0')
        template.tag.div(span_tag, class: 'input-group-append')
      end
    end
  end
end
