# frozen_string_literal: true

Schematics::Viewer::Migrator::SLIM = <<~SLIM
  .card.shadow-sm.animate__animated.animate__zoomIn
    .card-header.px-1.py-2
      = __card_heading(icon:, title:)
    .card-body.p-0
      ul.list-group.list-group-striped
        = __viewer_specifications_section(migrator_build_commands, icon: :plus, item_class: 'text-success')
        = __viewer_specifications_section(migrator_clean_commands, icon: :minus, item_class: 'text-danger')
SLIM
