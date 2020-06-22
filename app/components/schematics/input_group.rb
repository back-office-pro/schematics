module Schematics
  module InputGroup
    def prepend(wrapper_options)
      span_tag = content_tag(:span, options[:prepend], class: "input-group-text border-0")
      template.content_tag(:div, span_tag, class: "input-group-prepend")
    end

    def append(wrapper_options)
      span_tag = content_tag(:span, options[:append], class: "input-group-text border-0")
      template.content_tag(:div, span_tag, class: "input-group-append")
    end
  end
end
