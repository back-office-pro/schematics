# frozen_string_literal: true

PaperTrail.request(enabled: false) do
  Role.create!(name: 'Admin')
  Schematics::Schema
    .instance
    .entities
    .each(&Permission.method(:create_entity_permissions!))
end
