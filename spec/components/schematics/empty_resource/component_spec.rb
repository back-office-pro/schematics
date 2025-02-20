# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::EmptyResource::Component, type: :component do
  subject { render_inline described_class.new }

  let(:text) { I18n.t('schematics.application.resource.empty') }

  it { is_expected.to have_css('h4', text:) }
end
