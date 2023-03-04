# frozen_string_literal: true

namespace :schematics do
  namespace :systemd do
    desc 'Deploy systemd service'
    task deploy: :environment do
      File.write Tenant.systemd_service_path, Schematics::Engine.content_for('systemd.service')
      `systemctl daemon-reload`
      `systemctl enable #{Tenant.systemd_filename}`
      `systemctl start #{Tenant.systemd_filename}`
    end
  end
end
