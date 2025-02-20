# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/string/filters'
require 'rails/generators/generated_attribute'

describe Rails::Generators::GeneratedAttribute do
  subject(:attribute) { described_class.parse(column_definition) }

  include_context 'with custom generated attribute'

  context 'when column is string' do
    let(:column_definition) { 'foo:string' }

    its(:name) { is_expected.to eq('foo') }
    its(:column_name) { is_expected.to eq('foo') }
    its(:type) { is_expected.to eq(:string) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to be_empty }
    it { is_expected.not_to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", using: :btree, where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is string and unique' do
    let(:column_definition) { 'foo:string:uniq' }

    its(:name) { is_expected.to eq('foo') }
    its(:column_name) { is_expected.to eq('foo') }
    its(:type) { is_expected.to eq(:string) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to be_empty }
    it { is_expected.to have_index }
    it { is_expected.to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", unique: true, using: :btree, where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is string and has index' do
    let(:column_definition) { 'foo:string:index' }

    its(:name) { is_expected.to eq('foo') }
    its(:column_name) { is_expected.to eq('foo') }
    its(:type) { is_expected.to eq(:string) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to be_empty }
    it { is_expected.to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", using: :btree, where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is references' do
    let(:column_definition) { 'foo:references' }

    its(:name) { is_expected.to eq('foo') }
    its(:column_name) { is_expected.to eq('foo_id') }
    its(:type) { is_expected.to eq(:references) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to eq(index: { where: 'deleted_at IS NULL' }) }
    it { is_expected.not_to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", using: :btree, where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is jsonb' do
    let(:column_definition) { 'preferences:jsonb' }

    its(:name) { is_expected.to eq('preferences') }
    its(:column_name) { is_expected.to eq('preferences') }
    its(:type) { is_expected.to eq(:jsonb) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to be_empty }
    it { is_expected.not_to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", using: :gin, where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is polymorphic' do
    let(:column_definition) { 'record:belongs_to{polymorphic}:index' }

    its(:name) { is_expected.to eq('record') }
    its(:column_name) { is_expected.to eq('record_id') }
    its(:type) { is_expected.to eq(:belongs_to) }
    its(:attr_options) { is_expected.to eq(polymorphic: true) }
    it { is_expected.to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:options_for_migration) do
      is_expected.to eq(index: { where: 'deleted_at IS NULL' }, polymorphic: true)
    end

    its(:inject_index_options) do
      is_expected.to eq(', using: :btree')
    end
  end

  it_behaves_like 'a monkey patched instance super method',
                  :inject_index_options,
                  'f94f3e6427b118efcf79584543e98caeaf911f80b11e73cef28202cc2539e4c9'

  it_behaves_like 'a monkey patched instance super method',
                  :options_for_migration,
                  'fd2e945dbb711be9d9ecc3eb60ebb2cb9cba1c2eb08d4ce8c99c5964b221ff2f'

  it_behaves_like 'a monkey patched class super method',
                  :valid_type?,
                  '272809086174fcbc4d71dd8557096ee95512ffec4e7434e08c78f907b84dc49f'
end
