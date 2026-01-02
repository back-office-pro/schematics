# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Button::Help::Component, type: :component do
  subject { render_inline described_class.new(model_class:) }

  include_context 'with user'

  let(:text) { described_class.t('.text') }

  before { allow(vc_test_controller).to receive(:current_user).and_return(user) }

  context 'when model class is core but do not have external documentation' do
    let(:model_class) { User }

    it { is_expected.to have_no_link }
  end

  context 'when model class is core and have external documentation' do
    let(:model_class) { Migration }
    let(:path) { '/docs/en/reference/migrations' }

    it { is_expected.to have_link(text, href: website_url(path:)) }
  end

  context 'when model class is not core' do
    let(:model_class) { class_double('Prospect', entity: nil) } # rubocop:disable RSpec/VerifiedDoubleReference

    it { is_expected.to have_link(href: '#') }
  end

  context 'when there is no model class' do
    let(:model_class) { nil }
    let(:path) { '/docs/en/reference/' }

    it { is_expected.to have_link(text, href: website_url(path:)) }
  end
end
