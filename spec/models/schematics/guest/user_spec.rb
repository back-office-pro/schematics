# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Guest::User do
  subject(:user) { described_class.new(permissions:, time_zone:, locale:) }

  let(:time_zone) { 'UTC' }
  let(:locale) { 'en' }
  let(:permissions) { [Permission.new(action: 'create', model: 'User')] }

  it { is_expected.not_to be_admin }

  its(:id) { is_expected.to be_nil }
  its(:user_groups) { is_expected.to be_empty }
  its(:preferences) { is_expected.to be_empty }
  its(:user_drafts) { is_expected.to be_empty }
  its(:locale) { is_expected.to eq('en') }
  its(:time_zone) { is_expected.to eq('UTC') }
  its(:role) { is_expected.to be_a(Role) }
  its(:provisioning_uri) { is_expected.to be_nil }
end
