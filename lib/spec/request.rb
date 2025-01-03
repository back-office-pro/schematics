# frozen_string_literal: true

require_relative "#{Dir.pwd}/config/environment"

Tenant.schema.model_classes.each do
  RSpec.describe it, type: :request do
    include Schematics::Specs::Request
  end
end
