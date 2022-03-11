# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::ActiveStorage::AttachmentAbility do
  subject(:ability) { described_class.new(user) }

  fixtures :users
  fixtures :roles
  fixtures :permissions

  let(:user) { users(:one) }

  it { is_expected.not_to be_able_to(:destroy, ActiveStorage::Attachment, record_type: 'Import') }
end
