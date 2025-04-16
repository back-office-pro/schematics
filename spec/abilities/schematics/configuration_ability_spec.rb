# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::ConfigurationAbility do
  subject(:ability) { described_class.new(user) }

  include_context 'with admin role'

  let(:role) { Role.new }
  let(:user) { User.new(role:) }

  it { is_expected.not_to be_able_to(:show, Configuration) }
  it { is_expected.not_to be_able_to(:update, Configuration) }
  it { is_expected.not_to be_able_to(:update, Configuration, :gcloud_api_key) }
  it { is_expected.not_to be_able_to(:update, Configuration, :aws_access_key_id) }
  it { is_expected.not_to be_able_to(:update, Configuration, :aws_secret_access_key) }
  it { is_expected.not_to be_able_to(:update, Configuration, :aws_region) }
  it { is_expected.not_to be_able_to(:update, Configuration, :azure_storage_account_name) }
  it { is_expected.not_to be_able_to(:update, Configuration, :azure_storage_access_key) }
  it { is_expected.not_to be_able_to(:update, Configuration, :gcs_private_key_id) }
  it { is_expected.not_to be_able_to(:update, Configuration, :gcs_private_key) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:show, Configuration) }
    it { is_expected.to be_able_to(:update, Configuration) }
  end
end
