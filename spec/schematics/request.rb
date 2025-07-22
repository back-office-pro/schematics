# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

SchemaCache.model_classes.each do |model_class|
  RSpec.describe model_class, type: :request do
    include Schematics::Specs::Request
  end
end
