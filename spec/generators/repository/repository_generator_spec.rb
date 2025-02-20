# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'generators/repository/repository_generator'

RSpec.describe RepositoryGenerator do
  subject(:generator) { described_class.new([name], [], behavior:) }

  let(:name) { 'demo' }
  let(:client) do
    instance_double(Octokit::Client, create_repository: nil, delete_repository: nil)
  end

  before { allow(Octokit::Client).to receive(:new).and_return(client) }

  describe '#invoke_all' do
    subject(:invoke_all) { generator.invoke_all }

    before { invoke_all }

    context 'when invoking' do
      let(:behavior) { :invoke }

      it 'creates the repository' do
        expect(client).to have_received(:create_repository)
      end
    end

    context 'when revoking' do
      let(:behavior) { :revoke }

      it 'destroys the repository' do
        expect(client).to have_received(:delete_repository)
      end
    end

    context 'when revoking with a denied name' do
      let(:behavior) { :revoke }
      let(:name) { 'schematics' }

      it 'does not destroy the repository' do
        expect(client).not_to have_received(:delete_repository)
      end
    end
  end
end
