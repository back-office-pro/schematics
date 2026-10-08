# frozen_string_literal: true

Schematics::Viewer::Specifications::Entity::SLIM = <<~SLIM
  ul.list-group.list-group-striped
    = __viewer_specifications_section(element: @entity, options: true)
    = __viewer_specifications_section(fields, indent: 1, options: true)
    = __viewer_specifications_section(associations, indent: 1, options: true)
    = __viewer_specifications_section(triggers, icon: :atom, indent: 1)
SLIM
