# frozen_string_literal: true

describe Schematics::Attributes::Phone do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'user') }
  let(:name) { 'phone' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('phone') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:phone) }
  its(:default) { is_expected.to match(/\d+/) }
  its(:validators) { is_expected.to eq(phone: { allow_blank: true }) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.phone') }
  its(:to_s) { is_expected.to eq('schema:user_phone') }

  its(:validate) do
    is_expected.to eq <<~RUBY
      validates :phone, {:phone=>{:allow_blank=>true}}
    RUBY
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      phone: phone&.to_s
    RUBY
  end

  context 'when phone is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }

    its(:validators) do
      is_expected.to eq(
        uniqueness: { case_sensitive: true, allow_blank: true },
        phone: { allow_blank: true }
      )
    end

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :phone, {:uniqueness=>{:case_sensitive=>true, :allow_blank=>true}, :phone=>{:allow_blank=>true}}
      RUBY
    end
  end

  context 'when phone is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:validators) { is_expected.to eq(presence: true, phone: { allow_blank: false }) }

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :phone, {:presence=>true, :phone=>{:allow_blank=>false}}
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { '0613336807' }

    it { is_expected.to eq('061-333-6807') }
  end
end
