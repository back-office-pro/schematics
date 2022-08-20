# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::SchemaDatasetMapper do
  subject(:mapper) { described_class.new }

  describe '#call' do
    subject { mapper.call(params) }

    let(:params) do
      {
        'entities_attributes' => {
          '0' => {
            'id' => '123',
            'name' => 'product',
            'options_attributes' => {
              'descriptor' => 'price',
              'actions' => [
                'index'
              ],
              'icon' => 'box'
            },
            'attributes_attributes' => {
              '0' => {
                'id' => '123',
                'type' => 'string',
                'name' => 'foo',
                'options_attributes' => {
                  'required' => 'true',
                  'readonly' => 'false',
                  'min' => '50'
                }
              }
            },
            'virtuals_attributes' => {
              '0' => {
                'name' => 'price',
                'function' => '$foo',
                'options_attributes' => {
                  'unit' => '$',
                  'precision' => '2'
                }
              }
            },
            'triggers_attributes' => {
              '0' => {
                'action' => 'save',
                'callback' => '$foo = true'
              }
            }
          }
        }
      }
    end
    let(:expected_output) do
      {
        data: [
          {
            id: '123',
            name: 'product',
            options: {
              descriptor: 'price',
              actions: [
                'index'
              ],
              icon: 'box'
            },
            attributes: [
              {
                id: '123',
                name: 'foo',
                type: 'string',
                options: {
                  required: true,
                  min: 50
                }
              }
            ],
            virtuals: [
              {
                name: 'price',
                function: '$foo',
                options: {
                  unit: '$',
                  precision: 2
                }
              }
            ],
            triggers: [
              {
                action: 'save',
                callback: '$foo = true'
              }
            ]
          }
        ]
      }
    end

    it { is_expected.to eq(expected_output) }
  end
end
