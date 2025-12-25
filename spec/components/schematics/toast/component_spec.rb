# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Toast::Component, type: :component do
  subject { render_inline(component) }

  let(:component) { described_class.new(flash:) }
  let(:flash) { [type, message] }

  context 'when flash message is a notice' do
    let(:type) { 'notice' }
    let(:message) { I18n.t('sessions.create.success') }
    let(:text) { component.translate('.notice') }

    it { is_expected.to have_css('.bg-success') }
    it { is_expected.to have_css('strong', text:) }
    it { is_expected.to have_text(message) }
  end

  context 'when flash message is an alert' do
    let(:type) { 'alert' }
    let(:message) { I18n.t('schematics.home.destroy.success') }
    let(:text) { component.translate('.alert') }

    it { is_expected.to have_css('.bg-danger') }
    it { is_expected.to have_css('strong', text:) }
    it { is_expected.to have_text(message) }
  end
end
