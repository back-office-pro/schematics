require 'rails_helper'

RSpec.describe Schematics::Toast::Component, type: :component do
  subject { render_inline(described_class.new(flash: flash)) }

  let(:flash) { [type, message] }

  context 'when flash message is a notice' do
    let(:type) { 'notice' }
    let(:message) { 'Logged out!' }
    let(:title) { I18n.t('schematics.application.notice.title') }

    it { is_expected.to have_css('.border-success') }
    it { is_expected.to have_css('.bg-success') }
    it { is_expected.to have_selector('strong', text: title) }
    it { is_expected.to have_text(message) }
  end

  context 'when flash message is an alert' do
    let(:type) { 'alert' }
    let(:message) { 'Forbidden!' }
    let(:title) { I18n.t('schematics.application.alert.title') }

    it { is_expected.to have_css('.border-danger') }
    it { is_expected.to have_css('.bg-danger') }
    it { is_expected.to have_selector('strong', text: title) }
    it { is_expected.to have_text(message) }
  end
end
