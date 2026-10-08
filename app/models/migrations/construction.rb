# frozen_string_literal: true

module Migrations
  module Construction # rubocop:disable Metrics/ModuleLength
    module_function

    def data = [
      {
        id: SecureRandom.uuid,
        name: 'construction_site',
        options: {
          descriptor: 'location',
          icon: 'helmet_safety'
        },
        virtuals: [
          id: SecureRandom.uuid,
          name: 'cost',
          function: 'SUM($stock_movements.cost)',
          options: {
            precision: 2,
            unit: '$'
          }
        ],
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'location',
            type: 'address',
            options: {
              unique: true,
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'documents',
            type: 'attachments',
            options: {
              content_type: ['application/pdf']
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'construction_site_movement',
        options: {
          icon: 'person_digging'
        },
        associations: [
          name: 'users',
          type: 'has_and_belongs_to_many',
          options: {
            required: true
          }
        ],
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'start_at',
            type: 'datetime',
            options: {
              required: true,
              start_date: true,
              less_than: 'end_at'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'end_at',
            type: 'datetime',
            options: {
              required: true,
              end_date: true,
              greater_than: 'start_at'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'construction_site',
            type: 'belongs_to',
            options: {
              required: true
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'part',
        options: {
          descriptor: 'reference',
          icon: 'box'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'reference',
            type: 'string',
            options: {
              unique: true,
              required: true,
              limit: 100
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'price',
            type: 'currency',
            options: {
              required: true,
              precision: 2,
              unit: '$'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'quantity',
            type: 'integer',
            options: {
              readonly: true,
              default: 0
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'stock_movement',
        options: {
          icon: 'people_carry_box',
          actions: %w[index show create destroy]
        },
        triggers: [
          {
            id: SecureRandom.uuid,
            action: 'after_create',
            callback: '$part.quantity -= $quantity'
          },
          {
            id: SecureRandom.uuid,
            action: 'after_destroy',
            callback: '$part.quantity += $quantity'
          }
        ],
        virtuals: [
          id: SecureRandom.uuid,
          name: 'cost',
          function: '$part.price * $quantity',
          options: {
            precision: 2,
            unit: '$'
          }
        ],
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'quantity',
            type: 'integer',
            options: {
              required: true,
              greater_than_or_equal_to: 1
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'part',
            type: 'belongs_to',
            options: {
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'construction_site',
            type: 'belongs_to',
            options: {
              required: true
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'order',
        options: {
          icon: 'truck_fast',
          actions: %w[index show create destroy]
        },
        triggers: [
          {
            id: SecureRandom.uuid,
            action: 'after_create',
            callback: '$part.quantity += $quantity'
          },
          {
            id: SecureRandom.uuid,
            action: 'after_destroy',
            callback: '$part.quantity -= $quantity'
          }
        ],
        virtuals: [
          id: SecureRandom.uuid,
          name: 'cost',
          function: '$part.price * $quantity',
          options: {
            precision: 2,
            unit: '$'
          }
        ],
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'quantity',
            type: 'integer',
            options: {
              required: true,
              greater_than_or_equal_to: 1
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'part',
            type: 'belongs_to',
            options: {
              required: true
            }
          }
        ]
      }
    ]
  end
end
