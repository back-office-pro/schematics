# frozen_string_literal: true

Schematics::Viewer::EventButtonGroup::SLIM = <<~SLIM
  - events.each do |event|
    - if event.confirm
      = __viewer_event_button_group_confirm_button(resource:, event:, compact:, last: events.last)
    - else
      = __viewer_event_button_group_button(resource:, event:, compact:, last: events.last)
SLIM
