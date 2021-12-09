# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Toast::Component, type: :component do
  subject { render_inline described_class.new(flash:) }

  let(:flash) { [type, message] }

  context 'when flash message is a notice' do
    let(:type) { 'notice' }
    let(:message) { 'Logged out!' }
    let(:text) { component.translate('.notice') }

    it { is_expected.to have_css('.bg-success') }
    it { is_expected.to have_selector('strong', text:) }
    it { is_expected.to have_text(message) }
  end

  context 'when flash message is an alert' do
    let(:type) { 'alert' }
    let(:message) { 'Forbidden!' }
    let(:text) { component.translate('.alert') }

    it { is_expected.to have_css('.bg-danger') }
    it { is_expected.to have_selector('strong', text:) }
    it { is_expected.to have_text(message) }
  end
end
