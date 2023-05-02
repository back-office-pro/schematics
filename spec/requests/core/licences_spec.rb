# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::LicencesController, except: :trigger do
  include Schematics::Specs::Request
end
