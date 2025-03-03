# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SortLink::Component, type: :component do
  subject do
    with_request_url resources_path(Demo::User, sort:) do
      render_inline described_class.new(field:, model_class:)
    end
  end

  let(:model_class) { Demo::User }
  let(:field) { model_class.entity.find_field_by_name('email') }

  context 'when emails are not ordered' do
    let(:sort) { nil }

    it { is_expected.to have_link('Email', href: resources_path(Demo::User, sort: 'email')) }
    it { is_expected.to have_css('i', class: 'fa-envelope text-secondary') }
  end

  context 'when emails are not ordered and first names are in descendant order' do
    let(:sort) { '-first_name' }

    it { is_expected.to have_link('Email', href: resources_path(Demo::User, sort: '-first_name,email')) }
    it { is_expected.to have_css('i', class: 'fa-envelope text-secondary') }
  end

  context 'when emails are in ascendant order' do
    let(:sort) { 'email' }

    it { is_expected.to have_link('Email', href: resources_path(Demo::User, sort: '-email')) }
    it { is_expected.to have_css('i', class: 'fa-sort-down text-danger') }
  end

  context 'when emails are in descendant order' do
    let(:sort) { '-email' }

    it { is_expected.to have_link('Email', href: resources_path(Demo::User, sort: 'email')) }
    it { is_expected.to have_css('i', class: 'fa-sort-up text-success') }
  end
end
