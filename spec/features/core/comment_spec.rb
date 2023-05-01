# frozen_string_literal: true

require 'rails_helper'
require 'capybara/rspec'

RSpec.describe Comment, except: :create do
  include Schematics::Specs::Feature
end
