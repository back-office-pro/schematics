# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class RepositoryGenerator < Rails::Generators::NamedBase
  DENYLIST = %w[schematics ansible-playbook back-office.pro].freeze

  def generate_repository
    return unless generating?

    client.create_repository(
      name,
      organization: Server.organization,
      private: true
    )
  end

  def destroy_repository
    return unless destroying?
    return if DENYLIST.include?(name)

    client.delete_repository("#{Server.organization}/#{name}")
  end

  private

  def generating?
    behavior == :invoke
  end

  def destroying?
    behavior == :revoke
  end

  def access_token = Schematics::Engine
    .credentials
    .github
    .access_token

  def connection_options = { request: { open_timeout: 5, timeout: 5 } }

  memoize def client = Octokit::Client.new(access_token:, connection_options:)
end
