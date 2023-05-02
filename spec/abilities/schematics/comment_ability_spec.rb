# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::CommentAbility do
  subject(:ability) { described_class.new(user) }

  let(:user) { Core::User.new }
  let(:comment) { Core::Comment.new(author:) }

  it { is_expected.not_to be_able_to(:import, Core::Comment) }
  it { is_expected.not_to be_able_to(:duplicate, Core::Comment) }

  context 'when the user is not the author' do
    let(:author) { nil }

    it { is_expected.not_to be_able_to(:update, comment) }
    it { is_expected.not_to be_able_to(:destroy, comment) }
    it { is_expected.not_to be_able_to(:archive, comment) }
  end

  context 'when the user is the author' do
    let(:author) { user }

    it { is_expected.to be_able_to(:update, comment) }
    it { is_expected.to be_able_to(:destroy, comment) }
    it { is_expected.to be_able_to(:archive, comment) }
  end
end
