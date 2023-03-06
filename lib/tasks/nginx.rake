# frozen_string_literal: true

namespace :schematics do
  namespace :nginx do
    desc 'Deploy nginx subdomain'
    task deploy: :environment do
      Tenant.nginx_sites_available_path.write Schematics::Engine.content_for('nginx.conf')
      FileUtils.ln_s Tenant.nginx_sites_available_path, Tenant.nginx_sites_enabled_path
      `service nginx reload`
    end
  end
end
