# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class SystemdGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def generate_service
    return unless generating?
    return unless systemd_path.exist?

    template 'systemd.service', service_path
    template 'systemd.socket', socket_path
    `systemctl daemon-reload`
    `systemctl enable #{socket_filename} #{service_filename}`
    `systemctl start #{socket_filename} #{service_filename}`
  end

  def destroy_service
    return unless destroying?
    return unless systemd_path.exist?

    `systemctl stop #{socket_filename} #{service_filename}`
    `systemctl disable #{socket_filename} #{service_filename}`
    File.delete service_path
    File.delete socket_path
    `systemctl daemon-reload`
    `systemctl reset-failed`
  end

  private

  def generating?
    behavior == :invoke
  end

  def systemd_path = Pathname.new('/etc/systemd')

  def service_path = systemd_path.join('system', service_filename)

  def service_filename = "puma-#{name}.service"

  def socket_path = systemd_path.join('system', socket_filename)

  def socket_filename = "puma-#{name}.socket"

  def server_name = database_name
    .underscore
    .humanize

  def destroying?
    behavior == :revoke
  end
end
