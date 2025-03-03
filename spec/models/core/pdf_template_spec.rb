# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Demo::PDFTemplate do
  include Schematics::Specs::Model

  it_behaves_like 'an interpolable template'
end
