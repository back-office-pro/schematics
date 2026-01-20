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
  module Manufacturing
    module_function

    def data = [
      {
        id: SecureRandom.uuid,
        name: 'factory',
        options: {
          icon: 'industry',
          descriptor: 'name'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'name',
            type: 'string',
            options: {
              unique: true,
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'location',
            type: 'address',
            options: {
              required: true
            }
          }
        ]
      },
      {
        id: SecureRandom.uuid,
        name: 'product',
        options: {
          icon: 'wrench',
          descriptor: 'name'
        },
        attributes: [
          {
            id: SecureRandom.uuid,
            name: 'name',
            type: 'string',
            options: {
              unique: true,
              required: true
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'quantity',
            type: 'integer'
          },
          {
            id: SecureRandom.uuid,
            name: 'price',
            type: 'currency',
            options: {
              precision: 2,
              unit: '$'
            }
          },
          {
            id: SecureRandom.uuid,
            name: 'factory',
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
