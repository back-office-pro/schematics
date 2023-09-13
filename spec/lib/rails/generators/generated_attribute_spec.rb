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
    it { is_expected.to have_index }
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
    it { is_expected.to have_index }
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

  it_behaves_like 'a monkey patched instance method',
                  :column_name,
                  'c30e46955471cae44e0dc3019a548b26f16dcab4b10b4fdf919e511bd35c0347'

  it_behaves_like 'a monkey patched instance method',
                  :has_index?,
                  'c2c54719f5aa2b50bb11123c4fedf0299584be9351842dcfad3ee411744ed143'

  it_behaves_like 'a monkey patched instance method',
                  :has_uniq_index?,
                  '71951234f1a9fa31146c33744a3e4674f33b30c302b17a31051b5beb314d95e4'

  it_behaves_like 'a monkey patched instance method',
                  :inject_index_options,
                  'c7d83adfe8dca3c9f5ab09fe13eaaef231fd9442b15982f2aa4c84e0791a6e3b'

  it_behaves_like 'a monkey patched instance method',
                  :name,
                  'dcfc737644cd3a33f97d93e3f017abcfec2c0d59b5fb82140e36996b4263e27b'

  it_behaves_like 'a monkey patched instance method',
                  :options_for_migration,
                  '775b5e51791e66f42f49671f68480b0ecb418633df2d4bc1fc01c9d342030184'

  it_behaves_like 'a monkey patched instance method',
                  :plural_name,
                  'f65a4953c6c61b1785a2bd7b778b395c44ded5ab4266b36c224cf998076fa279'

  it_behaves_like 'a monkey patched instance method',
                  :reference?,
                  '8a53cedbddff22a4cb2951df128d7d1a3df31ca3e4b4f3171b6a52b0e5c48670'

  it_behaves_like 'a monkey patched instance method',
                  :required?,
                  '7816a4aa14fd677625e9d8d68a4ca7acf36dc6330f6ce36865e465f32b74df68'

  it_behaves_like 'a monkey patched instance method',
                  :type,
                  '476913719212cb12627952aef9a39e2efeeace4d32e506cde333c9f85851c424'

  it_behaves_like 'a monkey patched instance method',
                  :valid_type?,
                  '7da6bde00e94f9de3a9cc6ee17b1197b29fd01d27fc139fe3061c4e2d6bef5f2'
end
