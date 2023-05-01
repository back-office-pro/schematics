# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LicencesController, except: :trigger do
  include Schematics::Specs::Request
end
