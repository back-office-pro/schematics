require 'rails_helper'

RSpec.describe Schematics::EmptyResource::Component, type: :component do
  subject { render_inline(described_class.new) }

  let(:title) { I18n.t('schematics.application.empty.title') }

  it { is_expected.to have_selector('h4', text: title) }
end
