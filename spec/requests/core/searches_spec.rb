# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchesController, except: %i[index create] do
  include Schematics::Specs::Request
end
