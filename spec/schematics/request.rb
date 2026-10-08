# frozen_string_literal: true

require 'rails_helper'

load_current_schema
Schematics::SchemaCache.model_classes.each do |model_class|
  RSpec.describe model_class, type: :request do
    include Schematics::Specs::Request
  end
end
