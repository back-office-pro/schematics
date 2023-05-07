# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::BlogAbility do
  subject(:ability) { described_class.new }

  let(:post) { BlogPost.new }

  context 'when post is not published' do
    it { is_expected.not_to be_able_to(:read, post) }
  end

  context 'when post is published' do
    before { post.publish }

    it { is_expected.to be_able_to(:read, post) }
  end
end
