# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::FeatureFlagAbility do
  subject(:ability) { ability_class.new }

  let(:ability_class) do
    Class.new(described_class) do
      def initialize
        can :manage, [Message, Comment, Meeting, Task]
        super
      end
    end
  end

  it { is_expected.to be_able_to(:manage, Message) }
  it { is_expected.to be_able_to(:manage, Comment) }
  it { is_expected.to be_able_to(:manage, Meeting) }
  it { is_expected.to be_able_to(:manage, Task) }

  context 'when messages are disabled' do
    before { Configuration.instance.update!(messages_feature_flag: false) }

    it { is_expected.not_to be_able_to(:manage, Message) }
  end

  context 'when comments are disabled' do
    before { Configuration.instance.update!(comments_feature_flag: false) }

    it { is_expected.not_to be_able_to(:manage, Comment) }
  end

  context 'when tasks are disabled' do
    before { Configuration.instance.update!(tasks_feature_flag: false) }

    it { is_expected.not_to be_able_to(:manage, Task) }
  end

  context 'when meetings are disabled' do
    before { Configuration.instance.update!(meetings_feature_flag: false) }

    it { is_expected.not_to be_able_to(:manage, Meeting) }
  end
end
