# frozen_string_literal: true

namespace :schematics do
  namespace :nginx do
    desc 'Deploy nginx subdomain'
    task deploy: :environment do
      FileUtils.cp(Rails.root.join('config/nginx.conf'), Tenant.nginx_sites_available_path)
      FileUtils.ln_s(Tenant.nginx_sites_available_path, Tenant.nginx_sites_enabled_path)
      sh 'service nginx reload'
    end
  end
end
