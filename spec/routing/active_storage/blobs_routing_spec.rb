# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveStorage::BlobsController, except: %i[show destroy] do
  include Schematics::Specs::Routing
end
