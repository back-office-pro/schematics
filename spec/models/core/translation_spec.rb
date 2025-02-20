# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Translation do
  include Schematics::Specs::Model

  its(:cache_key) { is_expected.to start_with('translations/en') }
end
