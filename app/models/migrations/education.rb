# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Migrations
  module Education # rubocop:disable Metrics/ModuleLength
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
          {
            id: SecureRandom.uuid,
            name: 'full_name',
            function: '$first_name $last_name'
          }
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
        name: 'training',
        options: {
          icon: 'person_chalkboard',
          descriptor: 'title'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'title',
            type: 'string',
            options: {
              unique: true,
              required: true,
              translated: true
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
            name: 'document',
            type: 'attachment',
            options: {
              content_type: ['application/pdf']
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'purchase',
        options: {
          icon: 'cart_shopping'
        },
        virtuals: [
          {
            id: SecureRandom.uuid,
            name: 'income',
            function: '$training.price * ((100 - $discount_code.percentage) / 100)',
            options: {
              precision: 2,
              unit: '$'
            }
          }
        ],
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'customer',
            type: 'belongs_to',
            options: {
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'training',
            type: 'belongs_to',
            options: {
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'discount_code',
            type: 'belongs_to'
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'discount_code',
        options: {
          icon: 'tag',
          descriptor: 'value'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'value',
            type: 'string',
            options: {
              required: true,
              normalization: 'capitalize'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'percentage',
            type: 'percentage',
            options: {
              required: true,
              precision: 0,
              greater_than: 0,
              less_than_or_equal_to: 100
            }
          }
        ]
      }
    ]
  end
end
