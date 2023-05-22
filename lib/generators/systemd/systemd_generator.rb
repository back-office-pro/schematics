# frozen_string_literal: true

class SystemdGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  def generate_service
    return unless generating?
    return unless systemd_path.exist?

    template 'systemd.service', service_path
    `systemctl daemon-reload`
    `systemctl enable #{filename}`
    `systemctl start #{filename}`
  end

  def destroy_service
    return unless destroying?
    return unless systemd_path.exist?

    `systemctl stop #{filename}`
    `systemctl disable #{filename}`
    File.delete service_path
    `systemctl daemon-reload`
    `systemctl reset-failed`
  end

  private

  def generating?
    behavior == :invoke
  end

  def destroying?
    behavior == :revoke
  end

  def systemd_path = Pathname.new('/etc/systemd')

  def service_path = systemd_path.join('system', filename)

  def filename = "puma-#{Tenant.subdomain}.service"
end
