# frozen_string_literal: true

PaperTrail.request(enabled: false) do
  Role.create!(name: 'Admin', permissions: Permission.create_all_entities_permissions!)
  User.create!(email: ENV.fetch('ADMIN_USER_EMAIL', nil), role: Role.admin)
end
