# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require_relative "#{Dir.pwd}/config/environment"

SchemaCache.model_classes.each do |model_class|
  RSpec.describe model_class, type: :routing do
    include Schematics::Specs::Routing
  end
end
