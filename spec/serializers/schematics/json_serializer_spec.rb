# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::JsonSerializer do
  subject(:serializer) { described_class.new(user, options) }

  include_context 'with user'

  describe '#content' do
    subject { serializer.content }

    context 'when template is show' do
      let(:options) { { template: 'show' } }

      it { is_expected.to include('id' => be_a(String)) }
      it { is_expected.to include('email' => 'john.doe@nowhere.com') }
      it { is_expected.to include('firstName' => 'John') }
      it { is_expected.to include('lastName' => 'Doe') }
      it { is_expected.to include('locale' => 'en') }
      it { is_expected.to include('timeZone' => 'UTC') }
      it { is_expected.to include('fullName' => 'Doe John') }
      it { is_expected.to include('createdAt') }
      it { is_expected.to include('role' => { 'id' => be_a(String), 'name' => 'Manager' }) }
      it { is_expected.to include('userGroups') }
      it { is_expected.to include('sentMessages') }
      it { is_expected.to include('imports') }
      it { is_expected.to include('searches') }
      it { is_expected.to include('drafts') }
      it { is_expected.to include('sessions') }
      it { is_expected.to include('comments') }
      it { is_expected.not_to include('password') }
    end

    context 'when template is index' do
      let(:options) { { template: 'index' } }

      it { is_expected.to include('id' => be_a(String)) }
      it { is_expected.to include('email' => 'john.doe@nowhere.com') }
      it { is_expected.to include('firstName' => 'John') }
      it { is_expected.to include('lastName' => 'Doe') }
      it { is_expected.to include('locale' => 'en') }
      it { is_expected.to include('timeZone' => 'UTC') }
      it { is_expected.to include('fullName' => 'Doe John') }
      it { is_expected.to include('createdAt') }
      it { is_expected.to include('role' => { 'id' => be_a(String), 'name' => 'Manager' }) }
      it { is_expected.not_to include('userGroups') }
      it { is_expected.not_to include('sentMessages') }
      it { is_expected.not_to include('imports') }
      it { is_expected.not_to include('searches') }
      it { is_expected.not_to include('drafts') }
      it { is_expected.not_to include('sessions') }
      it { is_expected.not_to include('comments') }
      it { is_expected.not_to include('password') }
    end

    context 'when association option is enabled' do
      let(:options) { { association: true } }

      it { is_expected.to include('id' => be_a(String)) }
      it { is_expected.to include('fullName' => 'Doe John') }
    end

    context 'when metadata option is enabled' do
      let(:options) { { metadata: true } }
      let(:expected_metadata) do
        {
          _metadata: {
            icon: 'users',
            descriptor: 'Doe John',
            url: Rails.application.routes.url_helpers.polymorphic_path(user),
            sgid: be_a(String)
          }
        }
      end

      it { is_expected.to include('id' => be_a(String)) }
      it { is_expected.to include('email' => 'john.doe@nowhere.com') }
      it { is_expected.to include('firstName' => 'John') }
      it { is_expected.to include('lastName' => 'Doe') }
      it { is_expected.to include('locale' => 'en') }
      it { is_expected.to include('timeZone' => 'UTC') }
      it { is_expected.to include('fullName' => 'Doe John') }
      it { is_expected.to include('createdAt') }
      it { is_expected.to include('role' => { 'id' => be_a(String), 'name' => 'Manager' }) }
      it { is_expected.not_to include('userGroups') }
      it { is_expected.not_to include('sentMessages') }
      it { is_expected.not_to include('imports') }
      it { is_expected.not_to include('searches') }
      it { is_expected.not_to include('drafts') }
      it { is_expected.not_to include('sessions') }
      it { is_expected.not_to include('comments') }
      it { is_expected.not_to include('password') }
      it { is_expected.to include(expected_metadata) }
    end
  end
end
