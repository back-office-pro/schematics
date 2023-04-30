# frozen_string_literal: true

# :reek:MissingSafeMethod
class ApiKey < Schematics::ApplicationRecord
  def login!(*) = self

  def touch!(request)
    PaperTrail.request(enabled: false) do
      ApiRequest.create!(
        api_key: self,
        ip: request.ip,
        request_method: request.method,
        endpoint: request.original_fullpath
      )
    end
  end

  def user = Schematics::Guest::User.new(permissions:)
end
