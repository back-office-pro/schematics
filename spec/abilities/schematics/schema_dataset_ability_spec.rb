# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::SchemaDatasetAbility do
  subject(:ability) { described_class.new }

  it { is_expected.not_to be_able_to(:import, SchemaDataset) }
  it { is_expected.not_to be_able_to(:destroy, SchemaDataset.migrated) }
end
