# frozen_string_literal: true

describe Schematics::Schema do
  subject(:schema) { described_class.instance }

  it { is_expected.to be_valid }

  describe '#find_entity_by_name' do
    subject { schema.find_entity_by_name('user') }

    it { is_expected.to be_a(Schematics::Entities::Entity) }
  end

  context 'when there are name collisions' do
    let(:data) do # rubocop:disable Metrics/BlockLength
      {
        entities: [
          {
            name: 'user',
            attributes: [
              {
                name: 'role',
                type: 'belongs_to'
              }
            ]
          },
          {
            name: 'role',
            attributes: [
              {
                name: 'name',
                type: 'string'
              }
            ]
          },
          {
            name: 'message',
            attributes: [
              {
                name: 'author',
                type: 'belongs_to',
                options: {
                  type: 'user'
                }
              },
              {
                name: 'recipient',
                type: 'belongs_to',
                options: {
                  type: 'user'
                }
              }
            ]
          }
        ]
      }
    end
    let(:message_associations) do
      schema.find_entity_by_name('message').associations.map(&:name)
    end
    let(:user_associations) do
      schema.find_entity_by_name('user').associations.map(&:name)
    end

    before do
      allow_any_instance_of(described_class).to receive(:data).and_return(data) # rubocop:disable RSpec/AnyInstance
      Singleton.__init__(described_class)
    end

    it 'prefixes role associations of message entity' do
      expect(message_associations).to eq(%w[author_role recipient_role])
    end

    it 'prefixes message associations of user entity' do
      expect(user_associations).to eq(%w[author_messages recipient_messages])
    end
  end

  context 'when there are reserved words' do
    let(:data) do
      {
        entities: [
          {
            name: 'import',
            attributes: [
              {
                name: 'errors',
                type: 'jsonb'
              }
            ]
          }
        ]
      }
    end

    before do
      allow_any_instance_of(described_class).to receive(:data).and_return(data) # rubocop:disable RSpec/AnyInstance
      Singleton.__init__(described_class)
    end

    it { is_expected.not_to be_valid }
  end
end
