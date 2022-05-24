# frozen_string_literal: true

require 'rails'
require 'rails/generators/generated_attribute'

describe Rails::Generators::GeneratedAttribute do
  subject(:attribute) { described_class.parse(column_definition) }

  before do
    described_class
      .singleton_class
      .prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
    described_class
      .prepend(Schematics::Patches::Rails::Generators::GeneratedAttribute)
    allow(Rails)
      .to receive_message_chain( # rubocop:disable RSpec/MessageChain
        :application,
        :config,
        :active_record,
        :belongs_to_required_by_default
      ).and_return(true)
  end

  context 'when column is string' do
    let(:column_definition) { 'foo:string' }

    its(:name) { is_expected.to eq('foo') }
    its(:type) { is_expected.to eq(:string) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to be_empty }
    its(:default) { is_expected.to eq('MyString') }
    it { is_expected.not_to be_required }
    it { is_expected.to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", algorithm: :concurrently, where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is string and unique' do
    let(:column_definition) { 'foo:string:uniq' }

    its(:name) { is_expected.to eq('foo') }
    its(:type) { is_expected.to eq(:string) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to be_empty }
    its(:default) { is_expected.to eq('MyString') }
    it { is_expected.not_to be_required }
    it { is_expected.to have_index }
    it { is_expected.to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is string and has index' do
    let(:column_definition) { 'foo:string:index' }

    its(:name) { is_expected.to eq('foo') }
    its(:type) { is_expected.to eq(:string) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to be_empty }
    its(:default) { is_expected.to eq('MyString') }
    it { is_expected.not_to be_required }
    it { is_expected.to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", algorithm: :concurrently, where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is references' do
    let(:column_definition) { 'foo:references' }

    its(:name) { is_expected.to eq('foo') }
    its(:type) { is_expected.to eq(:references) }
    its(:attr_options) { is_expected.to be_empty }
    its(:default) { is_expected.to be_nil }
    it { is_expected.to be_required }
    it { is_expected.to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", algorithm: :concurrently, where: 'deleted_at IS NULL'")
    end

    its(:options_for_migration) do
      is_expected.to eq(null: false, foreign_key: true, index: { where: 'deleted_at IS NULL' })
    end
  end

  context 'when column is schema email' do
    let(:column_definition) { 'schema:user_email' }

    its(:name) { is_expected.to eq('email') }
    its(:type) { is_expected.to eq(:citext) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to eq(null: false) }
    it { expect(JSON.parse(attribute.default)).to match(URI::MailTo::EMAIL_REGEXP) }
    it { is_expected.to be_required }
    it { is_expected.to have_index }
    it { is_expected.to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq <<~TEXT.chomp
        , unique: true, algorithm: :concurrently, using: :btree, where: 'deleted_at IS NULL'
      TEXT
    end
  end

  context 'when column is schema references' do
    let(:column_definition) { 'schema:message_author' }

    its(:name) { is_expected.to eq('author') }
    its(:type) { is_expected.to eq(:references) }
    its(:attr_options) { is_expected.to eq(foreign_key: { to_table: :users }) }
    its(:default) { is_expected.to be_nil }
    it { is_expected.to be_required }
    it { is_expected.to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", algorithm: :concurrently, using: :btree, where: 'deleted_at IS NULL'")
    end

    its(:options_for_migration) do
      is_expected.to eq(
        null: false,
        foreign_key: { to_table: :users },
        index: { where: 'deleted_at IS NULL' }
      )
    end
  end
end
