# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message do
  include Schematics::Specs::Model

  its(:mentions) { is_expected.to be_empty }

  describe '#read?' do
    subject { record.read?(record.author) }

    it { is_expected.to be_falsy }
  end
end
