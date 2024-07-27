# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MigrationsController, except: %i[create] do
  include Schematics::Specs::Request
end
