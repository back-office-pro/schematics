# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Versions::UnreadQuery do
  subject(:query) { described_class }

  include_context 'with user'

  let(:read_notifications_at) { Time.current }
  let(:first_version) do
    Schematics::Version.create!(
      event: 'update',
      item: user,
      user:,
      created_at: Time.current.tomorrow
    )
  end
  let(:second_version) do
    Schematics::Version.create!(
      event: 'update',
      item: user,
      user:,
      created_at: Time.current.yesterday
    )
  end

  before { [first_version, second_version] }

  describe '.call' do
    subject { query.call(read_notifications_at) }

    it { is_expected.to contain_exactly(first_version) }
  end
end
