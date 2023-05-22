# frozen_string_literal: true

namespace :schematics do
  namespace :repo do
    desc 'Create Github repo'
    task create: :environment do
      uri = URI.parse('https://api.github.com/orgs/back-office-pro/repos')
      request = Net::HTTP::Post.new(uri)
      request.basic_auth(Schematics::Engine.credentials.github[:access_token], 'x-oauth-basic')
      request.body = { name: Tenant.subdomain, private: true }.to_json
      puts Net::HTTP
        .start(uri.hostname, uri.port, use_ssl: true) { _1.request(request) }
        .code
    end
  end
end
