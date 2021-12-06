# frozen_string_literal: true

describe Schematics::Attributes::Email do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'user') }
  let(:name) { 'email' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }

  its(:type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('email') }
  its(:icon) { is_expected.to eq(:envelope) }
  its(:input_type) { is_expected.to eq(:input) }
  its(:default) { is_expected.to be_nil }
  its(:validators) { is_expected.to eq(email: true) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.email') }
  its(:to_s) { is_expected.to eq('schema:user_email') }

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :email, {:email=>true}
    RUBY
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      email&.to_s
    RUBY
  end

  context 'when email is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }
    it { is_expected.to be_required }
    its(:default) { is_expected.to match(/\w+@\w+\.com/) }

    its(:validators) do
      is_expected.to eq(uniqueness: { case_sensitive: false }, presence: true, email: true)
    end

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :email, {:uniqueness=>{:case_sensitive=>false}, :presence=>true, :email=>true}
      RUBY
    end
  end

  context 'when email is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:validators) { is_expected.to eq(presence: true, email: true) }

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :email, {:presence=>true, :email=>true}
      RUBY
    end
  end
end
