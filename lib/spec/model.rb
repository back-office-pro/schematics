# frozen_string_literal: true

require_relative "#{Dir.pwd}/config/environment"

SchemaCache.model_classes.each do
  RSpec.describe it, type: :model do
    include Schematics::Specs::Model
  end
end
