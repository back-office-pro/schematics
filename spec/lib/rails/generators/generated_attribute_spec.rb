# frozen_string_literal: true

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
    it { is_expected.not_to be_required }
    it { is_expected.not_to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is string and unique' do
    let(:column_definition) { 'foo:string:uniq' }

    its(:name) { is_expected.to eq('foo') }
    its(:column_name) { is_expected.to eq('foo') }
    its(:type) { is_expected.to eq(:string) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to be_empty }
    it { is_expected.not_to be_required }
    it { is_expected.to have_index }
    it { is_expected.to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", unique: true, where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is string and has index' do
    let(:column_definition) { 'foo:string:index' }

    its(:name) { is_expected.to eq('foo') }
    its(:column_name) { is_expected.to eq('foo') }
    its(:type) { is_expected.to eq(:string) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to be_empty }
    it { is_expected.not_to be_required }
    it { is_expected.to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is references' do
    let(:column_definition) { 'foo:references' }

    its(:name) { is_expected.to eq('foo') }
    its(:column_name) { is_expected.to eq('foo_id') }
    its(:type) { is_expected.to eq(:references) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to eq(foreign_key: true) }
    it { is_expected.not_to be_required }
    it { is_expected.not_to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", where: 'deleted_at IS NULL'")
    end
  end

  context 'when column is schema email' do
    let(:column_definition) { 'schema:user_email' }

    its(:name) { is_expected.to eq('email') }
    its(:column_name) { is_expected.to eq('email') }
    its(:type) { is_expected.to eq(:citext) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to be_empty }
    it { is_expected.not_to be_required }
    it { is_expected.to have_index }
    it { is_expected.to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq <<~TEXT.chomp
        , unique: true, using: :btree, where: 'deleted_at IS NULL'
      TEXT
    end
  end

  context 'when column is schema references' do
    let(:column_definition) { 'schema:message_author' }

    its(:name) { is_expected.to eq('author') }
    its(:column_name) { is_expected.to eq('author_id') }
    its(:type) { is_expected.to eq(:references) }
    its(:attr_options) { is_expected.to be_empty }
    its(:options_for_migration) { is_expected.to eq(index: { where: 'deleted_at IS NULL' }) }
    it { is_expected.not_to be_required }
    it { is_expected.to have_index }
    it { is_expected.not_to have_uniq_index }

    its(:inject_index_options) do
      is_expected.to eq(", using: :btree, where: 'deleted_at IS NULL'")
    end
  end

  it_behaves_like 'a monkey patched instance super method',
                  :column_name,
                  'f4208221e6c245551b55c7ab7e52b2f21e52ff9f4b4a8dbf548202972369cd45'

  it_behaves_like 'a monkey patched instance super method',
                  :has_index?,
                  '1737fbde5d76e5195924f54599506b353ef94c897d069c65054cb92ea22387c7'

  it_behaves_like 'a monkey patched instance super method',
                  :has_uniq_index?,
                  'd6e16cbc10a955f483bd6907d95dee85fad84bbc6ecc0809176b785269283a4c'

  it_behaves_like 'a monkey patched instance super method',
                  :inject_index_options,
                  'f94f3e6427b118efcf79584543e98caeaf911f80b11e73cef28202cc2539e4c9'

  it_behaves_like 'a monkey patched instance super method',
                  :name,
                  '533bca45b3ba14b751bb61487cc502df6887840081339d4184e999199f9571e4'

  it_behaves_like 'a monkey patched instance super method',
                  :options_for_migration,
                  'fd2e945dbb711be9d9ecc3eb60ebb2cb9cba1c2eb08d4ce8c99c5964b221ff2f'

  it_behaves_like 'a monkey patched instance super method',
                  :plural_name,
                  '7de443f57b916b73cfd285863011a703b64b08fb7fe6a11bc8632281a0caf4f3'

  it_behaves_like 'a monkey patched instance super method',
                  :reference?,
                  '852b8392f8a0d72997cb7a0aa0a4c531af7da74ed6515e9c0caf4a3443eea532'

  it_behaves_like 'a monkey patched instance super method',
                  :required?,
                  'e37b612dcb78dfd1c36a35b267868ca9e9c021b38ffae82066cdc5fa65a3e1a9'

  it_behaves_like 'a monkey patched instance super method',
                  :type,
                  '533bca45b3ba14b751bb61487cc502df6887840081339d4184e999199f9571e4'

  it_behaves_like 'a monkey patched class super method',
                  :valid_type?,
                  '4641d809c6777a4517783b7bc133a97680bdf3dbdf5c50fc7df42b5a2be8875d'
end
