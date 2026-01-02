# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Attributes::RichText do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'summary' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Multisearchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Translatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }

  its(:database_type) { is_expected.to eq('rich_text') }
  its(:column_name) { is_expected.to eq('summary') }
  its(:open_api_body_type) { is_expected.to eq('string') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:input_name) { is_expected.to eq('entity[summary]') }
  its(:preload) { is_expected.to eq([rich_text_summary: [embeds_attachments: :blob]]) }
  its(:icon) { is_expected.to eq(:align_justify) }
  its(:default) { is_expected.to eq('MyRichText') }
  its(:to_sql) { is_expected.to eq('action_text_rich_texts.body') }
  its(:search_column) { is_expected.to eq(:rich_text_summary_body) }
  its(:search_column_association) { is_expected.to eq('rich_text_summary') }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:summary_i_cont) }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.summary') }

  its(:to_spec) do
    is_expected.to eq('A entity has a **summary** attribute of type *rich text editor*')
  end

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Readonly,
      Schematics::Options::Translated
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_rich_text :summary, store_if_blank: false
    RUBY
  end

  context 'when translated' do
    let(:options) { { translated: true } }

    its(:permitted_params) { is_expected.to eq(%i[summary summary_en summary_fr summary_it]) }

    its(:preload) do
      is_expected.to eq(
        [
          { rich_text_summary: [embeds_attachments: :blob] },
          :rich_text_translations
        ]
      )
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        translates :summary, backend: :action_text, column_fallback: false
      RUBY
    end
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class) }
  end
end
