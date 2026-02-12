# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Schema do
  subject(:schema) { described_class.new(data:) }

  let(:data) { [] }

  it { is_expected.to be_valid }
  its(:model_classes) { is_expected.to be_empty }

  describe '#find_entity_by_name' do
    subject { schema.find_entity_by_name('user') }

    it { is_expected.to be_a(Schematics::Entities::Entity) }
  end

  context 'when there are name collisions' do
    let(:data) do
      [
        {
          name: 'user',
          attributes: [
            name: 'role',
            type: 'belongs_to'
          ]
        },
        {
          name: 'role',
          attributes: [
            name: 'name',
            type: 'string'
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
    end
    let(:user_associations) do
      schema.find_entity_by_name('user').associations.map(&:name)
    end

    it 'prefixes message associations of user entity' do
      expect(user_associations).to include('author_messages', 'recipient_messages')
    end
  end

  context 'when there are dangerous attributes' do
    let(:data) do
      [
        name: 'import',
        attributes: [
          name: 'errors',
          type: 'jsonb'
        ]
      ]
    end

    it { is_expected.not_to be_valid }
  end

  context 'when there is a one-level circular association loop' do
    let(:data) do
      [
        {
          name: 'category',
          attributes: [
            name: 'sub_category',
            type: 'belongs_to'
          ]
        },
        {
          name: 'sub_category',
          attributes: [
            name: 'category',
            type: 'belongs_to'
          ]
        }
      ]
    end

    it { is_expected.not_to be_valid }
  end

  context 'when there is a two-level circular association loop' do
    let(:data) do
      [
        {
          name: 'category',
          attributes: [
            name: 'sub_category',
            type: 'belongs_to'
          ]
        },
        {
          name: 'sub_category',
          attributes: [
            name: 'product',
            type: 'belongs_to'
          ]
        },
        {
          name: 'product',
          attributes: [
            name: 'category',
            type: 'belongs_to'
          ]
        }
      ]
    end

    it { is_expected.not_to be_valid }
  end

  context 'when there is a more complex circular association loop' do
    let(:data) do
      [
        {
          name: 'category',
          attributes: [
            name: 'sub_category',
            type: 'belongs_to'
          ]
        },
        {
          name: 'sub_category',
          attributes: [
            {
              name: 'product',
              type: 'belongs_to'
            },
            {
              name: 'category',
              type: 'belongs_to'
            }
          ]
        },
        {
          name: 'product',
          attributes: [
            name: 'sub_category',
            type: 'belongs_to'
          ]
        }
      ]
    end

    it { is_expected.not_to be_valid }
  end

  context 'when there is a habtm circular association loop' do
    let(:data) do
      [
        {
          name: 'category',
          associations: [
            name: 'sub_categories',
            type: 'has_and_belongs_to_many'
          ]
        },
        {
          name: 'sub_category',
          associations: [
            name: 'categories',
            type: 'has_and_belongs_to_many'
          ]
        }
      ]
    end

    it { is_expected.not_to be_valid }
  end
end
