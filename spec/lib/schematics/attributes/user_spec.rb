# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Attributes::User do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) do
    Schematics::Entities::Entity.new(
      schema:,
      name: 'entity',
      options: {
        descriptor: 'type'
      },
      attributes: [
        { name: 'type', type: 'string' }
      ]
    )
  end
  let(:name) { 'user' }
  let(:options) { { inverse_association_type: 'has_many' } }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Indexable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:database_type) { is_expected.to eq('belongs_to') }
  its(:column_name) { is_expected.to eq('user_id') }
  its(:open_api_body_type) { is_expected.to eq('string') }
  its(:open_api_schema_type) { is_expected.to eq(id: 'string', full_name: 'string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:association_type) { is_expected.to eq('user') }
  its(:inverse_association_name) { is_expected.to eq('entity') }
  its(:inverse_association_type) { is_expected.to eq('has_many') }
  its(:class_name) { is_expected.to eq('User') }
  its(:preload) { is_expected.to eq([user: :string_translations]) }
  its(:icon) { is_expected.to eq(:users) }
  its(:weight) { is_expected.to eq(2) }
  its(:inverse_association) { is_expected.to be_a(Schematics::Associations::HasMany) }
  its(:allowed_association_types) { is_expected.to include('user', 'role') }
  its(:search_column) { is_expected.to eq(:user_full_name) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:user_i_cont) }
  its(:to_spec) { is_expected.to eq('A entity has a **user** attribute of type *current user*') }
  its(:to_s) { is_expected.to eq('user:belongs_to:index') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.user') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::InverseAssociationName,
      Schematics::Options::InverseAssociationType,
      Schematics::Options::Type,
      Schematics::Options::Polymorphic,
      Schematics::Options::Readonly
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      scope :with_user, -> { includes([{:user=>:string_translations}]) }
      scope :with_user_avatar, -> { includes({:user=>[{:avatar_attachment=>[{:blob=>:variant_records}]}]}) }
      scope :with_user_role, -> { includes({:user=>[{:role=>:string_translations}]}) }
      scope :with_user_teams, -> { includes({:user=>[:teams]}) }
      scope :with_user_sent_messages, -> { includes({:user=>[:sent_messages]}) }
      scope :with_user_imports, -> { includes({:user=>[:imports]}) }
      scope :with_user_searches, -> { includes({:user=>[:searches]}) }
      scope :with_user_user_drafts, -> { includes({:user=>[:user_drafts]}) }
      scope :with_user_sessions, -> { includes({:user=>[:sessions]}) }
      scope :with_user_migrations, -> { includes({:user=>[:migrations]}) }
      scope :with_user_author_comments, -> { includes({:user=>[:author_comments]}) }
      scope :with_user_requested_tasks, -> { includes({:user=>[:requested_tasks]}) }
      scope :with_user_created_meetings, -> { includes({:user=>[:created_meetings]}) }
      scope :with_user_sent_emails, -> { includes({:user=>[:sent_emails]}) }
      scope :with_user_record_drafts, -> { includes({:user=>[:record_drafts]}) }
      scope :with_user_record_comments, -> { includes({:user=>[:record_comments]}) }
      scope :with_user_record_emailings, -> { includes({:user=>[:record_emailings]}) }
      belongs_to :user,
                 -> { with_deleted },
                 class_name: 'User',
                 foreign_key: 'user_id',
                 inverse_of: :entities,
                 optional: true,
                 autosave: true
    RUBY
  end

  context 'when association is required' do
    let(:options) do
      {
        required: true,
        inverse_association_type: 'has_many'
      }
    end

    it { is_expected.to be_required }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        scope :with_user, -> { includes([{:user=>:string_translations}]) }
        scope :with_user_avatar, -> { includes({:user=>[{:avatar_attachment=>[{:blob=>:variant_records}]}]}) }
        scope :with_user_role, -> { includes({:user=>[{:role=>:string_translations}]}) }
        scope :with_user_teams, -> { includes({:user=>[:teams]}) }
        scope :with_user_sent_messages, -> { includes({:user=>[:sent_messages]}) }
        scope :with_user_imports, -> { includes({:user=>[:imports]}) }
        scope :with_user_searches, -> { includes({:user=>[:searches]}) }
        scope :with_user_user_drafts, -> { includes({:user=>[:user_drafts]}) }
        scope :with_user_sessions, -> { includes({:user=>[:sessions]}) }
        scope :with_user_migrations, -> { includes({:user=>[:migrations]}) }
        scope :with_user_author_comments, -> { includes({:user=>[:author_comments]}) }
        scope :with_user_requested_tasks, -> { includes({:user=>[:requested_tasks]}) }
        scope :with_user_created_meetings, -> { includes({:user=>[:created_meetings]}) }
        scope :with_user_sent_emails, -> { includes({:user=>[:sent_emails]}) }
        scope :with_user_record_drafts, -> { includes({:user=>[:record_drafts]}) }
        scope :with_user_record_comments, -> { includes({:user=>[:record_comments]}) }
        scope :with_user_record_emailings, -> { includes({:user=>[:record_emailings]}) }
        belongs_to :user,
                   -> { with_deleted },
                   class_name: 'User',
                   foreign_key: 'user_id',
                   inverse_of: :entities,
                   optional: false,
                   autosave: true
      RUBY
    end
  end

  context 'when association is polymorphic' do
    let(:options) do
      {
        polymorphic: true,
        inverse_association_type: 'has_many'
      }
    end

    it { is_expected.to be_polymorphic }

    its(:to_s) { is_expected.to eq('user:belongs_to{polymorphic}:index') }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        scope :with_user, -> { preload([{:user=>:string_translations}]) }
        belongs_to :user,
                   -> { with_deleted },
                   foreign_key: 'user_id',
                   inverse_of: :entities,
                   optional: true,
                   polymorphic: true,
                   autosave: true
      RUBY
    end
  end

  context 'when inverse association type is has_one' do
    let(:options) { { inverse_association_type: 'has_one' } }

    its(:inverse_association_type) { is_expected.to eq('has_one') }
    its(:inverse_association) { is_expected.to be_a(Schematics::Associations::HasOne) }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class, Schematics::Attributes::BelongsTo) }
  end
end
