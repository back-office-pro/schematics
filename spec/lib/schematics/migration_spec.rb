# frozen_string_literal: true

describe Schematics::Migration do
  subject(:migration) { described_class.new(current_schema, new_schema) }

  let(:current_schema) { Schematics::Schema.load(current_data) }
  let(:new_schema) { Schematics::Schema.load(new_data) }

  describe '#commands' do
    subject { migration.commands }

    context 'when creating a new entity' do
      let(:current_data) { [] }
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
      its(:size) { is_expected.to eq(1) }
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
      let(:new_data) { [] }

      its([0]) { is_expected.to be_a(Schematics::Commands::DestroyEntity) }
      its(:size) { is_expected.to eq(1) }
    end

    context 'when renaming an entity' do
      let(:current_data) do
        [
          {
            name: 'prospect',
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
              }
            ]
          }
        ]
      end

      its([0]) { is_expected.to be_a(Schematics::Commands::RenameEntity) }
      its(:size) { is_expected.to eq(1) }
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
      its(:size) { is_expected.to eq(1) }
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
      its(:size) { is_expected.to eq(1) }
    end

    context 'when renaming an attribute' do
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
              },
              {
                name: 'surname',
                type: 'string'
              }
            ]
          }
        ]
      end

      its([0]) { is_expected.to be_a(Schematics::Commands::RenameAttribute) }
      its(:size) { is_expected.to eq(1) }
    end

    context 'with a more complex scenario' do
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
            name: 'prospect',
            attributes: [
              {
                name: 'first_name',
                type: 'string'
              },
              {
                name: 'surname',
                type: 'string'
              }
            ]
          }
        ]
      end

      its([0]) { is_expected.to be_a(Schematics::Commands::RenameEntity) }
      its([1]) { is_expected.to be_a(Schematics::Commands::RenameAttribute) }
      its(:size) { is_expected.to eq(2) }
    end
  end
end
