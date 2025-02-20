# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'fileutils'

class NginxGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def generate_site_configuration
    return unless generating?
    return unless nginx_path.exist?

    empty_directory 'log'
    template 'nginx.conf', sites_available_path
    FileUtils.ln_s sites_available_path, sites_enabled_path
    `service nginx reload`
  end

  def destroy_site_configuration
    return unless destroying?
    return unless nginx_path.exist?

    File.delete sites_available_path
    File.delete sites_enabled_path
    `service nginx reload`
  end

  private

  def generating?
    behavior == :invoke
  end

  def nginx_path = Pathname.new('/etc/nginx')

  def sites_available_path = nginx_path.join('sites-available', name)

  def sites_enabled_path = nginx_path.join('sites-enabled', name)

  def upstream_name = name.underscore

  def destroying?
    behavior == :revoke
  end
end
