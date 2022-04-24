# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::SearchAbility do
  subject(:ability) { described_class.new }

  it { is_expected.to be_able_to(:create, Search) }
  it { is_expected.to be_able_to(:show, Search) }
end
