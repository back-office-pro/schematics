# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::DocumentationAbility do
  subject(:ability) { described_class.new(user, mod) }

  let(:mod) { Dummy }
  let(:role) { Role.new }
  let(:user) { User.new(role:) }
  let(:admin_role) { Role.create!(name: 'Admin') }

  before { stub_const('Dummy') }

  it { is_expected.not_to be_able_to(:show, ::Documentation) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:show, ::Documentation) }
  end
end
