# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe ActiveStorage::BlobAbility do
  subject(:ability) { described_class.new }

  let(:filename) { 'master.key' }
  let(:attachments) { { name: 'preview_image' } }

  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, filename:) }
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, attachments:) }
end
