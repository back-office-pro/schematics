# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::SortLink::Component, type: :component do
  subject { render_inline described_class.new(field:, model_class:) }

  let(:model_class) { User }
  let(:field) { model_class.entity.find_field_by_name('email') }

  context 'when emails are not ordered' do
    it { is_expected.to have_link('Email', href: users_path(sort: 'email')) }
    it { is_expected.to have_selector('i', class: 'fa-envelope text-secondary') }
  end

  context 'when emails are not ordered and first names are in descendant order' do
    before { allow(controller).to receive(:params).and_return(sort: '-first_name') }

    it { is_expected.to have_link('Email', href: users_path(sort: '-first_name,email')) }
    it { is_expected.to have_selector('i', class: 'fa-envelope text-secondary') }
  end

  context 'when emails are in ascendant order' do
    before { allow(controller).to receive(:params).and_return(sort: 'email') }

    it { is_expected.to have_link('Email', href: users_path(sort: '-email')) }
    it { is_expected.to have_selector('i', class: 'fa-sort-down text-danger') }
  end

  context 'when emails are in descendant order' do
    before { allow(controller).to receive(:params).and_return(sort: '-email') }

    it { is_expected.to have_link('Email', href: users_path(sort: 'email')) }
    it { is_expected.to have_selector('i', class: 'fa-sort-up text-success') }
  end
end
