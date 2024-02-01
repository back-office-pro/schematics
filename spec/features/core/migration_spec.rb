# frozen_string_literal: true

require 'rails_helper'
require 'capybara/rspec'

RSpec.describe Migration, except: %i[create update] do
  include Schematics::Specs::Feature
end
