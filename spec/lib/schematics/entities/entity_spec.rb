# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Entities::Entity do
  subject(:entity) { described_class.new(schema:, name:, attributes:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:name) { 'discussion' }
  let(:options) { { core: true, existing: true } }
  let(:attributes) do
    [
      {
        name: 'content',
        type: 'rich_text'
      },
      {
        name: 'record',
        type: 'belongs_to',
        options: {
          polymorphic: true
        }
      }
    ]
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_core }
  it { is_expected.to be_existing }
  it { is_expected.not_to be_abstract }
  it { is_expected.not_to be_child }
  it { is_expected.to be_valid }

  its(:icon) { is_expected.to eq(:circle_nodes) }
  its(:actions) { is_expected.to eq(%i[index show create update destroy archive]) }
  its(:class_name) { is_expected.to eq('Discussion') }
  its(:model_class) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(0) }
  its(:joins) { is_expected.to be_empty }
  its(:includes) { is_expected.to eq([rich_text_content: [embeds_attachments: :blob]]) }
  its(:preload) { is_expected.to eq([record: :string_translations]) }
  its(:digest) { is_expected.to eq('950d5abb604834b4815b3c40634a63ee') }
  its(:to_spec) { is_expected.to eq('We manage **discussions**') }
  its(:parent_entity) { is_expected.to be_nil }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Core,
      Schematics::Options::Hidden,
      Schematics::Options::Existing,
      Schematics::Options::Descriptor,
      Schematics::Options::Actions,
      Schematics::Options::Parent,
      Schematics::Options::Icon
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      class ::Discussion < Schematics::ApplicationRecord; end
    RUBY
  end

  context 'when entity name is not singular' do
    let(:name) { 'discussions' }

    it { is_expected.not_to be_valid }
  end

  context 'when entity name is reserved' do
    let(:name) { 'paper_trail_version' }

    it { is_expected.not_to be_valid }
  end

  context 'when entity name is dangerous' do
    let(:name) { 'association' }

    it { is_expected.not_to be_valid }
  end

  context 'when entity name is already taken' do
    let(:name) { 'user' }

    it { is_expected.not_to be_valid }
  end

  context 'when entity has a parent' do
    let(:parent_entity) { schema.find_entity_by_name('message') }
    let(:options) { { parent: 'message' } }

    it { is_expected.to be_child }

    its(:digest) { is_expected.to eq('07bcdbf90a8c4c9ad9dc844ff71586ca') }
    its(:parent_entity) { is_expected.to eq(parent_entity) }
  end
end
