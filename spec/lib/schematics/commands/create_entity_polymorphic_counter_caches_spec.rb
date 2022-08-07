# frozen_string_literal: true

describe Schematics::Commands::CreateEntityPolymorphicCounterCaches do
  subject(:command) { described_class.new(entity:) }

  before { stub_const('ActiveStorage::Attachment', Class.new) }

  let(:entity) { Schematics::Entities::Entity.new(name:) }
  let(:name) { 'assembly' }

  its(:execute) do
    is_expected.to eq(
      [
        'rails generate migration add_comments_count_to_assemblies comments_count:integer'
      ]
    )
  end

  context 'when entity class is already defined' do
    let(:name) { 'ActiveStorage::Attachment' }

    its(:execute) { is_expected.to be_empty }
  end
end
