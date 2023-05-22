# frozen_string_literal: true

class RepositoryGenerator < Rails::Generators::Base
  def generate_repository
    return unless generating?

    http(
      :post,
      201,
      'https://api.github.com/orgs/back-office-pro/repos',
      { name: Tenant.subdomain, private: true }
    )
  end

  def destroy_repository
    return unless destroying?

    http :delete, 204, "https://api.github.com/repos/back-office-pro/#{Tenant.subdomain}"
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

  # :reek:FeatureEnvy
  def http(type, code, url, body = nil)
    uri = URI.parse(url)
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(
        Net::HTTP
          .const_get(type.to_s.camelize)
          .new(uri)
          .tap { _1.basic_auth(access_token, 'x-oauth-basic') }
          .tap { _1.body = body&.to_json }
      )
    end
    raise response.body.to_s if response.code != code.to_s
  end
end
