# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dashboard do
  include Schematics::Specs::Model

  its(:icon) { is_expected.to eq(:user_lock) }
end
