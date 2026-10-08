# frozen_string_literal: true

module Migrations
  module Finance # rubocop:disable Metrics/ModuleLength
    module_function

    def data = [
      {
        id: SecureRandom.uuid,
        name: 'customer',
        options: {
          icon: 'user_tie',
          descriptor: 'full_name'
        },
        virtuals: [
          id: SecureRandom.uuid,
          name: 'full_name',
          function: '$first_name $last_name'
        ],
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'email',
            type: 'email',
            options: {
              unique: true,
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'first_name',
            type: 'string',
            options: {
              required: true,
              normalization: 'capitalize'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'last_name',
            type: 'string',
            options: {
              required: true,
              normalization: 'upcase'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'address',
            type: 'address',
            options: {
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'phone',
            type: 'phone',
            options: {
              required: true
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'portfolio',
        options: {
          icon: 'wallet'
        },
        virtuals: [
          id: SecureRandom.uuid,
          name: 'amount',
          function: 'SUM($investments.amount)',
          options: {
            precision: 2,
            unit: '$'
          }
        ],
        attributes: [
          id: SecureRandom.uuid,
          name: 'customer',
          type: 'belongs_to',
          options: {
            required: true
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'brokerage_account',
        options: {
          parent: 'portfolio'
        }
      },
      {
        id: SecureRandom.uuid,
        name: 'life_insurance',
        options: {
          parent: 'portfolio'
        },
        attributes: [
          id: SecureRandom.uuid,
          name: 'fees',
          type: 'percentage',
          options: {
            required: true
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'investment',
        options: {
          icon: 'dollar_sign'
        },
        virtuals: [
          {
            id: SecureRandom.uuid,
            name: 'amount',
            function: '$quantity * $instrument.price',
            options: {
              precision: 2,
              unit: '$'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'share',
            function: '$amount / $portfolio.amount * 100',
            options: {
              precision: 2,
              unit: '%'
            }
          }
        ],
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'portfolio',
            type: 'belongs_to',
            options: {
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'instrument',
            type: 'belongs_to',
            options: {
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'quantity',
            type: 'float',
            options: {
              required: true,
              greater_than: 0,
              precision: 2
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'instrument',
        options: {
          icon: 'chart_simple',
          descriptor: 'isin'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'isin',
            type: 'string',
            options: {
              unique: true,
              required: true,
              length: 12
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'type',
            type: 'enum',
            options: {
              required: true,
              values: %w[stock bond]
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'label',
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
              greater_than: 0,
              precision: 2,
              unit: '$'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'risk_level',
            type: 'integer',
            options: {
              required: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 7
            }
          }
        ]
      }
    ]
  end
end
