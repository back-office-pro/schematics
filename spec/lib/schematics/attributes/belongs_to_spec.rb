# frozen_string_literal: true

describe Schematics::Attributes::BelongsTo do
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
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_valid }

  its(:database_type) { is_expected.to eq('belongs_to') }
  its(:column_name) { is_expected.to eq('user_id') }
  its(:open_api_type) { is_expected.to eq(id!: String) }
  its(:association_type) { is_expected.to eq('user') }
  its(:inverse_association_name) { is_expected.to eq('entity') }
  its(:inverse_association_type) { is_expected.to eq('has_many_nested') }
  its(:class_name) { is_expected.to eq('User') }
  its(:preload) { is_expected.to eq([user: :string_translations]) }
  its(:icon) { is_expected.to eq(:users) }
  its(:to_sql) { is_expected.to eq("CONCAT(users.last_name, ' ', users.first_name)") }
  its(:weight) { is_expected.to eq(2) }
  its(:inverse_association) { is_expected.to be_a(Schematics::Associations::HasMany) }
  its(:allowed_association_types) { is_expected.to include('user', 'role') }
  its(:input_name) { is_expected.to eq('entity[user_id]') }
  its(:search_column) { is_expected.to eq(:user_full_name) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:user_i_cont) }
  its(:to_spec) { is_expected.to eq('A entity has a **user** attribute of type *association*') }

  its(:available_options) do # rubocop:disable RSpec/ExampleLength
    is_expected.to contain_exactly(
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

  its(:search_data) do
    is_expected.to eq <<~RUBY
      user: user&.to_s
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      scope :with_user, -> { includes([{:user=>:string_translations}]) }
      scope :with_user_avatar, -> { includes({:user=>[{:avatar_attachment=>[{:blob=>:variant_records}]}]}) }
      scope :with_user_role, -> { includes({:user=>[{:role=>:string_translations}]}) }
      scope :with_user_user_groups, -> { includes({:user=>[:user_groups]}) }
      scope :with_user_sent_messages, -> { includes({:user=>[:sent_messages]}) }
      scope :with_user_imports, -> { includes({:user=>[:imports]}) }
      scope :with_user_searches, -> { includes({:user=>[:searches]}) }
      scope :with_user_user_drafts, -> { includes({:user=>[:user_drafts]}) }
      scope :with_user_sessions, -> { includes({:user=>[:sessions]}) }
      scope :with_user_author_comments, -> { includes({:user=>[:author_comments]}) }
      scope :with_user_requested_tasks, -> { includes({:user=>[:requested_tasks]}) }
      scope :with_user_created_meetings, -> { includes({:user=>[:created_meetings]}) }
      scope :with_user_blog_posts, -> { includes({:user=>[:blog_posts]}) }
      scope :with_user_drafts, -> { includes({:user=>[:drafts]}) }
      scope :with_user_comments, -> { includes({:user=>[:comments]}) }
      belongs_to :user,
                 -> { with_deleted },
                 class_name: 'User',
                 foreign_key: 'user_id',
                 inverse_of: :entities,
                 optional: true,
                 autosave: true
    RUBY
  end

  context 'when belongs_to is required' do
    let(:options) do
      {
        required: true
      }
    end

    it { is_expected.to be_required }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        scope :with_user, -> { includes([{:user=>:string_translations}]) }
        scope :with_user_avatar, -> { includes({:user=>[{:avatar_attachment=>[{:blob=>:variant_records}]}]}) }
        scope :with_user_role, -> { includes({:user=>[{:role=>:string_translations}]}) }
        scope :with_user_user_groups, -> { includes({:user=>[:user_groups]}) }
        scope :with_user_sent_messages, -> { includes({:user=>[:sent_messages]}) }
        scope :with_user_imports, -> { includes({:user=>[:imports]}) }
        scope :with_user_searches, -> { includes({:user=>[:searches]}) }
        scope :with_user_user_drafts, -> { includes({:user=>[:user_drafts]}) }
        scope :with_user_sessions, -> { includes({:user=>[:sessions]}) }
        scope :with_user_author_comments, -> { includes({:user=>[:author_comments]}) }
        scope :with_user_requested_tasks, -> { includes({:user=>[:requested_tasks]}) }
        scope :with_user_created_meetings, -> { includes({:user=>[:created_meetings]}) }
        scope :with_user_blog_posts, -> { includes({:user=>[:blog_posts]}) }
        scope :with_user_drafts, -> { includes({:user=>[:drafts]}) }
        scope :with_user_comments, -> { includes({:user=>[:comments]}) }
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

  context 'when belongs_to is polymorphic' do
    let(:options) do
      {
        polymorphic: true
      }
    end

    it { is_expected.to be_polymorphic }

    its(:permitted_params) { is_expected.to eq(%i[user_id user_type]) }

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

  context 'when attribute name is dangerous' do
    let(:name) { 'association' }

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is already taken' do
    let(:name) { 'type' }

    it { is_expected.not_to be_valid }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class, Schematics::Attributes::User) }
  end
end
