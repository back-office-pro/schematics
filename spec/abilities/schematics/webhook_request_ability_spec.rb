# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::WebhookRequestAbility do
  subject(:ability) { described_class.new(user) }

  include_context 'with admin role'

  let(:role) { Role.new }
  let(:user) { User.new(role:) }

  it { is_expected.not_to be_able_to(:read, WebhookRequest) }
  it { is_expected.not_to be_able_to(:retry, WebhookRequest) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:read, WebhookRequest) }
    it { is_expected.to be_able_to(:retry, WebhookRequest) }
  end
end
