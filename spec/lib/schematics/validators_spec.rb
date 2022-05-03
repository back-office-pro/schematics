# frozen_string_literal: true

describe Schematics::Validators do
  subject { described_class.new(name:, validators:) }

  let(:name) { 'avatar' }

  context 'when validators are empty' do
    let(:validators) { {} }

    its(:compact_validators) { is_expected.to be_empty }
    its(:to_str) { is_expected.to be_blank }
    its(:human) { is_expected.to be_empty }
  end

  context 'when there are validators' do
    let(:validators) do
      {
        antivirus: true,
        attached: nil,
        size: {
          less_than: 2.megabytes,
          greater_than: nil
        }
      }
    end

    its(:compact_validators) do
      is_expected.to eq(antivirus: true, size: { less_than: 2.megabytes })
    end

    its(:human) do
      is_expected.to eq(
        [
          'Your files will be analyzed by an antivirus',
          'File size Less than 2 MB'
        ]
      )
    end

    its(:to_str) do
      is_expected.to eq <<~RUBY
        validates :avatar, {:antivirus=>true, :size=>{:less_than=>2097152}}
      RUBY
    end
  end
end
