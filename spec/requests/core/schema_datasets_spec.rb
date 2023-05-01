# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SchemaDatasetsController, except: %i[create update] do
  include Schematics::Specs::Request
end
