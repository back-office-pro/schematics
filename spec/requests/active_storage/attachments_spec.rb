# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveStorage::AttachmentsController, except: %i[show destroy] do
  include Schematics::Specs::Request
end
