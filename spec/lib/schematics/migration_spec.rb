# frozen_string_literal: true

describe Schematics::Migration do
  subject(:migration) { described_class.new(current_schema, new_schema) }

  let(:current_schema) { Schematics::Schema.load(current_data) }
  let(:new_schema) { Schematics::Schema.load(new_data) }

  describe '#commands' do
    subject { migration.commands }

    context 'when creating a new entity' do
      let(:current_data) { nil }
      let(:new_data) do
        [
          {
            name: 'client',
            attributes: [
              {
                name: 'first_name',
                type: 'string'
              }
            ]
          }
        ]
      end

      its([0]) { is_expected.to be_a(Schematics::Commands::CreateEntity) }
    end

    context 'when removing an entity' do
      let(:current_data) do
        [
          {
            name: 'client',
            attributes: [
              {
                name: 'first_name',
                type: 'string'
              }
            ]
          }
        ]
      end
      let(:new_data) { nil }

      its([0]) { is_expected.to be_a(Schematics::Commands::DestroyEntity) }
    end

    context 'when adding a new attribute' do
      let(:current_data) do
        [
          {
            name: 'client',
            attributes: [
              {
                name: 'first_name',
                type: 'string'
              }
            ]
          }
        ]
      end
      let(:new_data) do
        [
          {
            name: 'client',
            attributes: [
              {
                name: 'first_name',
                type: 'string'
              },
              {
                name: 'last_name',
                type: 'string'
              }
            ]
          }
        ]
      end

      its([0]) { is_expected.to be_a(Schematics::Commands::AddAttribute) }
    end

    context 'when removing an attribute' do
      let(:current_data) do
        [
          {
            name: 'client',
            attributes: [
              {
                name: 'first_name',
                type: 'string'
              },
              {
                name: 'last_name',
                type: 'string'
              }
            ]
          }
        ]
      end
      let(:new_data) do
        [
          {
            name: 'client',
            attributes: [
              {
                name: 'first_name',
                type: 'string'
              }
            ]
          }
        ]
      end

      its([0]) { is_expected.to be_a(Schematics::Commands::RemoveAttribute) }
    end
  end
end
