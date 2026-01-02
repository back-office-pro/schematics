# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::TeamAbility do
  subject(:ability) { ability_class.new(user, schema) }

  include_context 'with user'

  let(:ability_class) do
    Class.new(described_class) do
      def initialize(user, schema)
        can :read, :all
        super
      end
    end
  end
  let(:schema) { Schematics::Schema.new }
  let(:first_team) { Team.create!(name: 'My Team 1') }
  let(:second_team) { Team.create!(name: 'My Team 2') }
  let(:other_user) do
    User.create!(
      email: 'jane.doe@nowhere.com',
      role:,
      teams: other_teams
    )
  end
  let(:task) do
    Task.create!(
      title: 'My Task',
      applicant: user,
      assigneds: [user],
      teams: other_teams
    )
  end
  let(:meeting) do
    Meeting.create!(
      subject: 'My Meeting',
      creator: user,
      start_at: Time.current,
      end_at: 1.hour.from_now,
      teams: other_teams,
      participants: [user]
    )
  end

  before { [first_team, second_team, other_user, task, meeting] }

  context 'when teams are empty' do
    let(:teams) { [] }
    let(:other_teams) { [] }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.to be_able_to(:read, task) }
    it { is_expected.to be_able_to(:read, meeting) }
  end

  context 'when teams are identical' do
    let(:teams) { [first_team] }
    let(:other_teams) { [first_team] }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.to be_able_to(:read, task) }
    it { is_expected.to be_able_to(:read, meeting) }
  end

  context 'when resources have two teams' do
    let(:teams) { [first_team] }
    let(:other_teams) { [first_team, second_team] }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.to be_able_to(:read, task) }
    it { is_expected.to be_able_to(:read, meeting) }
  end

  context 'when user has two teams' do
    let(:teams) { [first_team, second_team] }
    let(:other_teams) { [first_team] }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.to be_able_to(:read, task) }
    it { is_expected.to be_able_to(:read, meeting) }
  end

  context 'when resources teams are empty' do
    let(:teams) { [first_team] }
    let(:other_teams) { [] }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.to be_able_to(:read, task) }
    it { is_expected.to be_able_to(:read, meeting) }
  end

  context 'when user teams are empty' do
    let(:teams) { [] }
    let(:other_teams) { [first_team] }

    it { is_expected.not_to be_able_to(:read, other_user) }
    it { is_expected.not_to be_able_to(:read, task) }
    it { is_expected.not_to be_able_to(:read, meeting) }
  end

  context 'when teams are different' do
    let(:teams) { [first_team] }
    let(:other_teams) { [second_team] }

    it { is_expected.not_to be_able_to(:read, other_user) }
    it { is_expected.not_to be_able_to(:read, task) }
    it { is_expected.not_to be_able_to(:read, meeting) }
  end
end
