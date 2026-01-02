# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Commands::AddAssociation do
  subject(:command) { described_class.new(entity:, attribute:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'client') }
  let(:attribute) do
    Schematics::Associations::Association.build(
      type: 'has_and_belongs_to_many',
      entity:,
      name: 'users'
    )
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:weight) { is_expected.to eq(2) }

  its(:to_spec) do
    is_expected.to eq('Add a many-to-many association between **client** and **users**')
  end

  describe '#generators' do
    subject { command.generators }

    its(:size) { is_expected.to eq(2) }
    its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
    its([1]) { is_expected.to be_a(TranslationGenerator) }

    its([0]) do
      is_expected.to have_attributes(
        name: 'create_join_table_clients_users',
        behavior: :invoke
      )
    end

    its([1]) do
      is_expected.to have_attributes(
        name: 'activerecord.attributes.client.users',
        behavior: :invoke
      )
    end
  end
end
