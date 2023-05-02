# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe ActiveStorage::AttachmentAbility do
  subject(:ability) { described_class.new(user) }

  let(:role) { Core::Role.new }
  let(:user) { Core::User.new(role:) }
  let(:record_type) { 'ActiveStorage::VariantRecord' }

  it { is_expected.not_to be_able_to(:destroy, ActiveStorage::Attachment, record_type: 'Import') }
  it { is_expected.not_to be_able_to(:read, ActiveStorage::Attachment, record_type:) }
end
