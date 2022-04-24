# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::SessionAbility do
  subject(:ability) { described_class.new(user) }

  fixtures :sessions, :users

  let(:session) { sessions(:one) }
  let(:user) { session.user }

  it { is_expected.to be_able_to(:destroy, session) }
end
