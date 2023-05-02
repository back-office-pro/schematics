# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::DraftAbility do
  subject(:ability) { described_class.new(user) }

  let(:user) { Core::User.new }
  let(:draft) { Core::Draft.new(user:) }

  it { is_expected.to be_able_to(:create, Core::Draft) }
  it { is_expected.to be_able_to(:show, draft) }
  it { is_expected.to be_able_to(:update, draft) }
  it { is_expected.to be_able_to(:destroy, draft) }
end
