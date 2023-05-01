# frozen_string_literal: true

require 'rails_helper'
require 'capybara/rspec'

RSpec.describe SchemaDataset, except: :update do
  include Schematics::Specs::Feature
end
