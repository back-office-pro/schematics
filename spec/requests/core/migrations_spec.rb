# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MigrationsController, except: %i[create update] do
  include Schematics::Specs::Request
end
