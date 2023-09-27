# frozen_string_literal: true

class RepositoryGenerator < Rails::Generators::Base
  def generate_repository
    return unless generating?

    client.create_repository(
      Tenant.subdomain,
      organization: Tenant.organization,
      private: true
    )
  end

  def destroy_repository
    return unless destroying?

    client.delete_repository("#{Tenant.organization}/#{Tenant.subdomain}")
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
    .github[:access_token]

  def connection_options = { request: { open_timeout: 5, timeout: 5 } }

  memoize def client = Octokit::Client.new(access_token:, connection_options:)
end
