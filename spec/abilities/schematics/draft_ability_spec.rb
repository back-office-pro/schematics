# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::DraftAbility do
  subject(:ability) { described_class.new(user) }

  fixtures :drafts, :users

  let(:draft) { drafts(:one) }
  let(:user) { draft.user }

  it { is_expected.to be_able_to(:create, Draft) }
  it { is_expected.to be_able_to(:show, draft) }
  it { is_expected.to be_able_to(:update, draft) }
  it { is_expected.to be_able_to(:destroy, draft) }
end
