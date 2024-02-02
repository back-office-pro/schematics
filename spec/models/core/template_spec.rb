# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Template do
  include Schematics::Specs::Model

  include_context 'with user'

  describe '#interpolate' do
    subject { record.interpolate(user) }

    before { record.content = content }

    context 'when content has a variable' do
      let(:content) { 'Email: {{ email }}' }

      it { is_expected.to eq('Email: john.doe@nowhere.com') }
    end

    context 'when content has a nested variable' do
      let(:content) { 'Role: {{ role.name }}' }

      it { is_expected.to eq('Role: Manager') }
    end

    context 'when content has an association iteration' do
      let(:content) do
        <<~LIQUID
          {% for user_group in user_groups -%}
            {{ user_group.name }}
          {%- endfor %}
        LIQUID
      end

      it { is_expected.to eq('My Group 2My Group 1') }
    end

    context 'when content has an unknown variable' do
      let(:content) { 'Email: {{ foo }}' }

      it { is_expected.to eq('Email: ') }
    end

    context 'when content has a filter' do
      let(:content) { 'Email: {{ email | upcase }}' }

      it { is_expected.to eq('Email: JOHN.DOE@NOWHERE.COM') }
    end

    context 'when content has an unknown filter' do
      let(:content) { 'Email: {{ email | titleize }}' }

      it { is_expected.to eq('Email: ') }
    end

    context 'when content has a syntax error' do
      let(:content) { 'Email: {{ foo }' }

      it { is_expected.to be_nil }
    end
  end

  describe '#interpolation_errors' do
    subject { record.interpolation_errors }

    before do
      record.content = content
      record.interpolate(user)
    end

    context 'when content has a variable' do
      let(:content) { 'Email: {{ email }}' }

      it { is_expected.to be_empty }
    end

    context 'when content has a nested variable' do
      let(:content) { 'Role: {{ role.name }}' }

      it { is_expected.to be_empty }
    end

    context 'when content has an association iteration' do
      let(:content) do
        <<~LIQUID
          {% for user_group in user_groups -%}
            {{ user_group.name }}
          {%- endfor %}
        LIQUID
      end

      it { is_expected.to be_empty }
    end

    context 'when content has an unknown variable' do
      let(:content) { 'Email: {{ foo }}' }

      it { is_expected.to all(be_a(Liquid::UndefinedVariable)) }
    end

    context 'when content has a filter' do
      let(:content) { 'Email: {{ email | upcase }}' }

      it { is_expected.to be_empty }
    end

    context 'when content has an unknown filter' do
      let(:content) { 'Email: {{ email | titleize }}' }

      it { is_expected.to all(be_a(Liquid::UndefinedFilter)) }
    end

    context 'when content has a syntax error' do
      let(:content) { 'Email: {{ foo }' }

      it { is_expected.to all(be_a(Liquid::SyntaxError)) }
    end
  end
end
