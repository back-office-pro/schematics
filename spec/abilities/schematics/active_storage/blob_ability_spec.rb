# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::ActiveStorage::BlobAbility do
  subject(:ability) { described_class.new }

  let(:filename) { %w[.env master.key db.dump] }

  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, filename:) }
end
