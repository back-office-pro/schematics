# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Demo::Documentation do
  include Schematics::Specs::Model

  its(:data) { is_expected.to be_empty }
end
