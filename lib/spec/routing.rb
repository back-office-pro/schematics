# frozen_string_literal: true

require_relative "#{Dir.pwd}/config/environment"

Tenant.controller_classes.each do
  RSpec.describe it, type: :routing do
    include Schematics::Specs::Routing
  end
end
