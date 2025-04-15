# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require_relative "#{Dir.pwd}/config/environment"

SchemaCache.model_classes.each do
  RSpec.describe it, type: :routing do
    include Schematics::Specs::Routing
  end
end
