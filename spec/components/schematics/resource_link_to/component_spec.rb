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

RSpec.describe Schematics::ResourceLinkTo::Component, type: :component do
  subject { render_inline described_class.new(resource:) }

  include_context 'with user'
  include_context 'with admin role'

  let(:role) { admin_role }

  context 'when resource is undefined without ability' do
    let(:resource) { 'Undefined' }

    it { is_expected.to have_css('i', class: 'fa-question') }
    it { is_expected.to have_text('Undefined') }
  end

  context 'when resource is user instance without ability' do
    let(:resource) { user }

    it { is_expected.to have_css('i', class: 'fa-users') }
    it { is_expected.to have_text('DOE John') }
  end

  context 'when resource is user class without ability' do
    let(:resource) { User }

    it { is_expected.to have_css('i', class: 'fa-users') }
    it { is_expected.to have_text('User') }
  end

  context 'when resource is undefined with ability' do
    let(:resource) { 'Undefined' }

    before { allow(vc_test_controller).to receive(:current_user).and_return(user) }

    it { is_expected.to have_css('i', class: 'fa-question') }
    it { is_expected.to have_text('Undefined') }
  end

  context 'when resource is user instance with ability' do
    let(:resource) { user }

    before { allow(vc_test_controller).to receive(:current_user).and_return(user) }

    it { is_expected.to have_css('i', class: 'fa-users') }
    it { is_expected.to have_link('DOE John', href: resource_path(resource)) }
  end

  context 'when resource is user class with ability' do
    let(:resource) { User }

    before { allow(vc_test_controller).to receive(:current_user).and_return(user) }

    it { is_expected.to have_css('i', class: 'fa-users') }
    it { is_expected.to have_link('User', href: resources_path(resource)) }
  end
end
