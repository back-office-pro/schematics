# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailTemplate do
  include Schematics::Specs::Model

  it_behaves_like 'an interpolable template'
end
