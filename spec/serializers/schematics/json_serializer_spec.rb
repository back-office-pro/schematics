# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::JSONSerializer do
  include Schematics::ResourcesHelper

  subject(:serializer) { described_class.new(user, options) }

  include_context 'with user'

  describe '#content' do
    subject { serializer.content }

    context 'when template is show' do
      let(:options) { { template: 'show' } }
      let(:expected_teams) do
        [
          { 'id' => be_a(String), 'name' => 'My Team 2' },
          { 'id' => be_a(String), 'name' => 'My Team 1' }
        ]
      end

      it { is_expected.to include('id' => be_a(String)) }
      it { is_expected.to include('email' => 'john.doe@nowhere.com') }
      it { is_expected.to include('first_name' => 'John') }
      it { is_expected.to include('last_name' => 'DOE') }
      it { is_expected.to include('locale' => 'en') }
      it { is_expected.to include('time_zone' => 'UTC') }
      it { is_expected.to include('full_name' => 'DOE John') }
      it { is_expected.to include('created_at' => be_a(ActiveSupport::TimeWithZone)) }
      it { is_expected.to include('role' => { 'id' => be_a(String), 'name' => 'Manager' }) }
      it { is_expected.to include('teams' => expected_teams) }
      it { is_expected.to include('sent_messages') }
      it { is_expected.to include('imports') }
      it { is_expected.to include('searches') }
      it { is_expected.to include('record_drafts') }
      it { is_expected.to include('sessions') }
      it { is_expected.to include('record_comments') }
      it { is_expected.not_to include('password') }
    end

    context 'when template is index' do
      let(:options) { { template: 'index' } }

      it { is_expected.to include('id' => be_a(String)) }
      it { is_expected.to include('email' => 'john.doe@nowhere.com') }
      it { is_expected.to include('first_name' => 'John') }
      it { is_expected.to include('last_name' => 'DOE') }
      it { is_expected.to include('locale' => 'en') }
      it { is_expected.to include('time_zone' => 'UTC') }
      it { is_expected.to include('full_name' => 'DOE John') }
      it { is_expected.to include('created_at' => be_a(ActiveSupport::TimeWithZone)) }
      it { is_expected.to include('role' => { 'id' => be_a(String), 'name' => 'Manager' }) }
      it { is_expected.not_to include('teams') }
      it { is_expected.not_to include('sent_messages') }
      it { is_expected.not_to include('imports') }
      it { is_expected.not_to include('searches') }
      it { is_expected.not_to include('record_drafts') }
      it { is_expected.not_to include('sessions') }
      it { is_expected.not_to include('record_comments') }
      it { is_expected.not_to include('password') }
    end

    context 'when association option is enabled' do
      let(:options) { { association: true } }

      it { is_expected.to include('id' => be_a(String)) }
      it { is_expected.to include('full_name' => 'DOE John') }
    end

    context 'when metadata option is enabled' do
      let(:options) { { metadata: true } }
      let(:expected_metadata) do
        {
          _metadata: {
            icon: 'users',
            descriptor: 'DOE John',
            url: resource_path(user),
            sgid: be_a(String)
          }
        }
      end

      it { is_expected.to include('id' => be_a(String)) }
      it { is_expected.to include('email' => 'john.doe@nowhere.com') }
      it { is_expected.to include('first_name' => 'John') }
      it { is_expected.to include('last_name' => 'DOE') }
      it { is_expected.to include('locale' => 'en') }
      it { is_expected.to include('time_zone' => 'UTC') }
      it { is_expected.to include('full_name' => 'DOE John') }
      it { is_expected.to include('created_at' => be_a(ActiveSupport::TimeWithZone)) }
      it { is_expected.to include('role' => { 'id' => be_a(String), 'name' => 'Manager' }) }
      it { is_expected.not_to include('teams') }
      it { is_expected.not_to include('sent_messages') }
      it { is_expected.not_to include('imports') }
      it { is_expected.not_to include('searches') }
      it { is_expected.not_to include('record_drafts') }
      it { is_expected.not_to include('sessions') }
      it { is_expected.not_to include('record_comments') }
      it { is_expected.not_to include('password') }
      it { is_expected.to include(expected_metadata) }
    end

    context 'when expand option is enabled' do
      let(:options) { { template: 'show', expand: true } }
      let(:expected_role) do
        {
          'created_at' => be_a(String),
          'id' => be_a(String),
          'name' => 'Manager'
        }
      end
      let(:expected_teams) do
        [
          {
            'created_at' => be_a(String),
            'id' => be_a(String),
            'name' => 'My Team 2'
          },
          {
            'created_at' => be_a(String),
            'id' => be_a(String),
            'name' => 'My Team 1'
          }
        ]
      end

      it { is_expected.to include('id' => be_a(String)) }
      it { is_expected.to include('email' => 'john.doe@nowhere.com') }
      it { is_expected.to include('first_name' => 'John') }
      it { is_expected.to include('last_name' => 'DOE') }
      it { is_expected.to include('locale' => 'en') }
      it { is_expected.to include('time_zone' => 'UTC') }
      it { is_expected.to include('full_name' => 'DOE John') }
      it { is_expected.to include('created_at' => be_a(ActiveSupport::TimeWithZone)) }
      it { is_expected.to include('role' => expected_role) }
      it { is_expected.to include('teams' => expected_teams) }
      it { is_expected.to include('sent_messages') }
      it { is_expected.to include('imports') }
      it { is_expected.to include('searches') }
      it { is_expected.to include('record_drafts') }
      it { is_expected.to include('sessions') }
      it { is_expected.to include('record_comments') }
      it { is_expected.not_to include('password') }
    end
  end
end
