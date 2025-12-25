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

RSpec.describe Schematics::SortLink::Component, type: :component do
  subject do
    with_request_url resources_path(User, sort:) do
      render_inline described_class.new(field:, model_class:)
    end
  end

  let(:model_class) { User }
  let(:field) { model_class.entity.find_field_by_name('email') }

  context 'when emails are not ordered' do
    let(:sort) { nil }

    it { is_expected.to have_link('Email', href: resources_path(User, sort: 'email')) }
    it { is_expected.to have_css('i', class: 'fa-envelope text-secondary') }
  end

  context 'when emails are not ordered and first names are in descendant order' do
    let(:sort) { '-first_name' }

    it { is_expected.to have_link('Email', href: resources_path(User, sort: '-first_name,email')) }
    it { is_expected.to have_css('i', class: 'fa-envelope text-secondary') }
  end

  context 'when emails are in ascendant order' do
    let(:sort) { 'email' }

    it { is_expected.to have_link('Email', href: resources_path(User, sort: '-email')) }
    it { is_expected.to have_css('i', class: 'fa-sort-down text-danger') }
  end

  context 'when emails are in descendant order' do
    let(:sort) { '-email' }

    it { is_expected.to have_link('Email', href: resources_path(User, sort: 'email')) }
    it { is_expected.to have_css('i', class: 'fa-sort-up text-success') }
  end
end
