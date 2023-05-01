# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchesController, except: %i[create not_found] do
  include Schematics::Specs::Request
end
