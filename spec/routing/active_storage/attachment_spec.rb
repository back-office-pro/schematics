# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveStorage::Attachment, except: %i[show destroy] do
  include Schematics::Specs::Routing
end
