# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::ActiveStorage::AttachmentAbility do
  subject(:ability) { described_class.new(user) }

  fixtures :users, :roles, :permissions

  let(:user) { users(:one) }
  let(:record_type) { %w[ActiveStorage::VariantRecord ActiveStorage::Blob] }

  it { is_expected.not_to be_able_to(:destroy, ActiveStorage::Attachment, record_type: 'Import') }
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Attachment, record_type:) }
end
