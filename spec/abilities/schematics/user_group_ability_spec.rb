# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::UserGroupAbility do
  subject(:ability) { ability_class.new(user) }

  include_context 'with user'

  let(:ability_class) do
    Class.new(described_class) do
      def initialize(user)
        can :read, model_classes
        super
      end
    end
  end
  let(:first_user_group) { UserGroup.create!(name: 'My Group 1') }
  let(:second_user_group) { UserGroup.create!(name: 'My Group 2') }
  let(:other_user) do
    User.create!(
      email: 'jane.doe@nowhere.com',
      role:,
      user_groups: other_user_groups
    )
  end
  let(:task) do
    Task.create!(
      title: 'My Task',
      applicant: user,
      assigneds: [user],
      user_groups: other_user_groups
    )
  end
  let(:meeting) do
    Meeting.create!(
      subject: 'My Meeting',
      creator: user,
      start_at: Time.current,
      end_at: 1.hour.from_now,
      user_groups: other_user_groups,
      participants: [user]
    )
  end

  before { [first_user_group, second_user_group, other_user, task, meeting] }

  context 'when user groups are empty' do
    let(:user_groups) { [] }
    let(:other_user_groups) { [] }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.to be_able_to(:read, task) }
    it { is_expected.to be_able_to(:read, meeting) }
  end

  context 'when user groups are identical' do
    let(:user_groups) { [first_user_group] }
    let(:other_user_groups) { [first_user_group] }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.to be_able_to(:read, task) }
    it { is_expected.to be_able_to(:read, meeting) }
  end

  context 'when resources have two user groups' do
    let(:user_groups) { [first_user_group] }
    let(:other_user_groups) { [first_user_group, second_user_group] }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.to be_able_to(:read, task) }
    it { is_expected.to be_able_to(:read, meeting) }
  end

  context 'when user has two user groups' do
    let(:user_groups) { [first_user_group, second_user_group] }
    let(:other_user_groups) { [first_user_group] }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.to be_able_to(:read, task) }
    it { is_expected.to be_able_to(:read, meeting) }
  end

  context 'when resources user groups are empty' do
    let(:user_groups) { [first_user_group] }
    let(:other_user_groups) { [] }

    it { is_expected.to be_able_to(:read, other_user) }
    it { is_expected.to be_able_to(:read, task) }
    it { is_expected.to be_able_to(:read, meeting) }
  end

  context 'when user user groups are empty' do
    let(:user_groups) { [] }
    let(:other_user_groups) { [first_user_group] }

    it { is_expected.not_to be_able_to(:read, other_user) }
    it { is_expected.not_to be_able_to(:read, task) }
    it { is_expected.not_to be_able_to(:read, meeting) }
  end

  context 'when user groups are different' do
    let(:user_groups) { [first_user_group] }
    let(:other_user_groups) { [second_user_group] }

    it { is_expected.not_to be_able_to(:read, other_user) }
    it { is_expected.not_to be_able_to(:read, task) }
    it { is_expected.not_to be_able_to(:read, meeting) }
  end
end
