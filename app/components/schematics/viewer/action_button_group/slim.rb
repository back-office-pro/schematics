# frozen_string_literal: true

Schematics::Viewer::ActionButtonGroup::SLIM = <<~SLIM
  .btn-group
    - if deleted?
      = __button_restore(resource:)
    - else
      = __button_edit(resource:)
      = __viewer_event_button_group(resource:)
      = __button_archive(resource:)
SLIM
