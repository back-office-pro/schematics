# frozen_string_literal: true

require 'rails_helper'
require 'capybara/rspec'

RSpec.describe Core::Draft do
  include Schematics::Specs::Feature
end
