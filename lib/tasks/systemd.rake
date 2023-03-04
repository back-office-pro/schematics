# frozen_string_literal: true

namespace :schematics do
  namespace :systemd do
    desc 'Deploy systemd service'
    task deploy: :environment do
      File.write Tenant.systemd_service_path, Schematics::Engine.content_for('systemd.service')
      `systemctl daemon-reload`
      `systemctl enable #{Tenant.subdomain}.service`
      `systemctl start #{Tenant.subdomain}.service`
    end
  end
end
