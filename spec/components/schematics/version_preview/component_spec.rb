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

RSpec.describe Schematics::VersionPreview::Component, type: :component do
  subject { render_inline described_class.new(version:) }

  include_context 'with user'
  include_context 'with admin role'

  let(:role) { admin_role }
  let(:version) { Schematics::Version.create!(event:, item: user, user:, object:) }

  before { allow(vc_test_controller).to receive(:current_user).and_return(user) }

  context 'when version has a create event' do
    let(:event) { 'create' }
    let(:object) { nil }

    it { is_expected.to have_link(user.to_s, href: resource_path(user)) }
    it { is_expected.to have_no_css('.row[role]') }
    it { is_expected.to have_no_css('.row[data-action]') }
    it { is_expected.to have_no_css('.row[data-application-href-param]') }
  end

  context 'when version has a update event' do
    let(:event) { 'update' }
    let(:object) { user.as_json }

    it { is_expected.to have_link(user.to_s, href: resource_path(user)) }
    it { is_expected.to have_css('.row[role]') }
    it { is_expected.to have_css('.row[data-action]') }
    it { is_expected.to have_css('.row[data-application-href-param]') }
  end

  context 'when version has a destroy event' do
    let(:event) { 'destroy' }
    let(:object) { nil }

    before { user.really_destroy! }

    it { is_expected.to have_no_link(user.to_s, href: resource_path(user)) }
    it { is_expected.to have_no_css('.row[role]') }
    it { is_expected.to have_no_css('.row[data-action]') }
    it { is_expected.to have_no_css('.row[data-application-href-param]') }
  end

  context 'when version has a archive event' do
    let(:event) { 'archive' }
    let(:object) { nil }

    before { user.destroy! }

    it { is_expected.to have_no_link(user.to_s, href: resource_path(user)) }
    it { is_expected.to have_no_css('.row[role]') }
    it { is_expected.to have_no_css('.row[data-action]') }
    it { is_expected.to have_no_css('.row[data-application-href-param]') }
  end
end
