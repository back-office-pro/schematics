# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe ActiveStorage::BlobAbility do
  subject(:ability) { described_class.new }

  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, filename: 'db.dump') }
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, filename: 'license.json') }
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, attachments: { name: 'preview_image' }) } # rubocop:disable Layout/LineLength
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, attachments: { record_type: 'Backup' }) } # rubocop:disable Layout/LineLength
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Blob, attachments: { record_type: 'LinkPreview' }) } # rubocop:disable Layout/LineLength
end
