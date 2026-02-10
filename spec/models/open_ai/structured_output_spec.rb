# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAI::StructuredOutput do
  let(:expected_hash) do
    {
      type: 'object',
      properties: {
        name: {
          type: 'string',
          description: <<~TEXT.squish
            The unique entity name at singular, in snake case and in english. The name must not be among #{Schematics::Schema.new.entities.map(&:name).concat(Schematics::Entities::Entity::NAME_DENYLIST).to_sentence}
          TEXT
        },
        options: {
          type: 'object',
          properties: {
            descriptor: {
              type: 'string',
              description: 'The attribute name which represents the most the entity'
            },
            icon: { '$ref': '#/$defs/icon' }
          },
          additionalProperties: false,
          required: %w[descriptor icon]
        },
        attributes: {
          type: 'array',
          items: {
            anyOf: [
              { '$ref': '#/$defs/address' },
              { '$ref': '#/$defs/array' },
              { '$ref': '#/$defs/attachment' },
              { '$ref': '#/$defs/attachments' },
              { '$ref': '#/$defs/belongs_to' },
              { '$ref': '#/$defs/boolean' },
              { '$ref': '#/$defs/byte' },
              { '$ref': '#/$defs/code' },
              { '$ref': '#/$defs/color' },
              { '$ref': '#/$defs/country' },
              { '$ref': '#/$defs/currency' },
              { '$ref': '#/$defs/date' },
              { '$ref': '#/$defs/datetime' },
              { '$ref': '#/$defs/decimal' },
              { '$ref': '#/$defs/digest' },
              { '$ref': '#/$defs/duration' },
              { '$ref': '#/$defs/email' },
              { '$ref': '#/$defs/enum' },
              { '$ref': '#/$defs/flag' },
              { '$ref': '#/$defs/float' },
              { '$ref': '#/$defs/integer' },
              { '$ref': '#/$defs/ip' },
              { '$ref': '#/$defs/jsonb' },
              { '$ref': '#/$defs/mime' },
              { '$ref': '#/$defs/one_time_password' },
              { '$ref': '#/$defs/percentage' },
              { '$ref': '#/$defs/phone' },
              { '$ref': '#/$defs/rating' },
              { '$ref': '#/$defs/response_code' },
              { '$ref': '#/$defs/rich_text' },
              { '$ref': '#/$defs/secret' },
              { '$ref': '#/$defs/state_machine' },
              { '$ref': '#/$defs/string' },
              { '$ref': '#/$defs/text' },
              { '$ref': '#/$defs/time' },
              { '$ref': '#/$defs/time_zone' },
              { '$ref': '#/$defs/token' },
              { '$ref': '#/$defs/url' },
              { '$ref': '#/$defs/user' },
              { '$ref': '#/$defs/user_agent' }
            ]
          }
        }
      },
      '$defs': {
        acceptance: {
          type: 'object',
          additionalProperties: false,
          required: %w[acceptance],
          properties: {
            acceptance: {
              type: 'boolean',
              description: 'Does the attribute must be accepted or not'
            }
          }
        },
        aspect_ratio: {
          type: 'object',
          additionalProperties: false,
          required: %w[aspect_ratio],
          properties: {
            aspect_ratio: {
              type: 'array',
              description: 'The aspect ratios of the image',
              items: {
                type: 'string',
                enum: %w[is_16_9 is_4_3 landscape square]
              }
            }
          }
        },
        auto_increment: {
          type: 'object',
          additionalProperties: false,
          required: %w[auto_increment],
          properties: {
            auto_increment: {
              type: 'boolean',
              description: 'Is the number auto incrementable or not'
            }
          }
        },
        case_insensitive: {
          type: 'object',
          additionalProperties: false,
          required: %w[case_insensitive],
          properties: {
            case_insensitive: {
              type: 'boolean',
              description: 'Is the string case insensitive or not'
            }
          }
        },
        confirm: {
          type: 'object',
          additionalProperties: false,
          required: %w[confirm],
          properties: {
            confirm: {
              type: 'boolean',
              description: 'Has the password to be confirmed or not'
            }
          }
        },
        default: {
          type: 'object',
          additionalProperties: false,
          required: %w[default],
          properties: {
            default: {
              type: 'string',
              description: 'Default value of the attribute'
            }
          }
        },
        delimiter: {
          type: 'object',
          additionalProperties: false,
          required: %w[delimiter],
          properties: {
            delimiter: {
              type: 'string',
              description: 'The number thousands separator',
              enum: %w[, .]
            }
          }
        },
        end_date: {
          type: 'object',
          additionalProperties: false,
          required: %w[end_date],
          properties: {
            end_date: {
              type: 'boolean',
              description: 'Is the date the end of a calendar range'
            }
          }
        },
        content_type: {
          type: 'object',
          additionalProperties: false,
          required: %w[content_type],
          properties: {
            content_type: {
              type: 'array',
              description: 'The content types of the attachment',
              items: {
                type: 'string',
                enum: %w[image/png]
              }
            }
          }
        },
        equal_to: {
          type: 'object',
          additionalProperties: false,
          required: %w[equal_to],
          properties: {
            equal_to: {
              type: 'number',
              description: 'The number should be equal to'
            }
          }
        },
        events: {
          type: 'object',
          additionalProperties: false,
          required: %w[events],
          properties: {
            events: {
              type: 'array',
              description: 'State machine events',
              items: {
                type: 'object',
                properties: {
                  name: { '$ref': '#/$defs/name' },
                  icon: { '$ref': '#/$defs/icon' },
                  color: {
                    type: 'string',
                    description: 'The event style',
                    enum: %w[primary secondary success danger warning]
                  },
                  confirm: {
                    type: 'boolean',
                    description: 'Does the event action need to be confirmed'
                  },
                  from: {
                    type: 'string',
                    description: 'The starting value of the event transition'
                  },
                  to: {
                    type: 'string',
                    description: 'The ending value of the event transition'
                  }
                },
                additionalProperties: false,
                required: %w[name icon color confirm from to]
              }
            }
          }
        },
        greater_than_or_equal_to: {
          type: 'object',
          additionalProperties: false,
          required: %w[greater_than_or_equal_to],
          properties: {
            greater_than_or_equal_to: {
              type: 'number',
              description: 'The number should be greater than or equal to'
            }
          }
        },
        greater_than: {
          type: 'object',
          additionalProperties: false,
          required: %w[greater_than],
          properties: {
            greater_than: {
              type: 'number',
              description: 'The number should be greater than'
            }
          }
        },
        height: {
          type: 'object',
          additionalProperties: false,
          required: %w[height],
          properties: {
            height: {
              type: 'number',
              description: 'The height of the image in pixels'
            }
          }
        },
        inverse_association_type: {
          type: 'object',
          additionalProperties: false,
          required: %w[inverse_association_type],
          properties: {
            inverse_association_type: {
              type: 'string',
              description: 'The inverse type of the association',
              enum: %w[has_many has_one]
            }
          }
        },
        language: {
          type: 'object',
          additionalProperties: false,
          required: %w[language],
          properties: {
            language: {
              type: 'string',
              description: 'The language of the code editor',
              enum: %w[
                abap
                aes
                apex
                azcli
                bat
                bicep
                c
                cameligo
                clojure
                coffeescript
                cpp
                csharp
                csp
                css
                cypher
                dart
                dockerfile
                ecl
                elixir
                flow9
                freemarker2
                freemarker2.tag-angle.interpolation-bracket
                freemarker2.tag-angle.interpolation-dollar
                freemarker2.tag-auto.interpolation-bracket
                freemarker2.tag-auto.interpolation-dollar
                freemarker2.tag-bracket.interpolation-bracket
                freemarker2.tag-bracket.interpolation-dollar
                fsharp
                go
                graphql
                handlebars
                hcl
                html
                ini
                java
                javascript
                json
                julia
                kotlin
                less
                lexon
                liquid
                lua
                m3
                markdown
                mdx
                mips
                msdax
                mysql
                objective-c
                pascal
                pascaligo
                perl
                pgsql
                php
                pla
                plaintext
                postiats
                powerquery
                powershell
                proto
                pug
                python
                qsharp
                r
                razor
                redis
                redshift
                restructuredtext
                ruby
                rust
                sb
                scala
                scheme
                scss
                shell
                sol
                sparql
                sql
                st
                swift
                systemverilog
                tcl
                twig
                typescript
                vb
                verilog
                wgsl
                xml
                yaml
              ]
            }
          }
        },
        length: {
          type: 'object',
          additionalProperties: false,
          required: %w[length],
          properties: {
            length: {
              type: 'number',
              description: 'The exact length of the text'
            }
          }
        },
        less_than_or_equal_to: {
          type: 'object',
          additionalProperties: false,
          required: %w[less_than_or_equal_to],
          properties: {
            less_than_or_equal_to: {
              type: 'number',
              description: 'The number should be less than or equal to'
            }
          }
        },
        less_than: {
          type: 'object',
          additionalProperties: false,
          required: %w[less_than],
          properties: {
            less_than: {
              type: 'number',
              description: 'The number should be less than'
            }
          }
        },
        limit: {
          type: 'object',
          additionalProperties: false,
          required: %w[limit],
          properties: {
            limit: {
              type: 'number',
              description: 'The maximum length of the text'
            }
          }
        },
        max: {
          type: 'object',
          additionalProperties: false,
          required: %w[max],
          properties: {
            max: {
              type: 'number',
              description: 'The maximum number of attachments'
            }
          }
        },
        min: {
          type: 'object',
          additionalProperties: false,
          required: %w[min],
          properties: {
            min: {
              type: 'number',
              description: 'The minimum length of the text'
            }
          }
        },
        normalization: {
          type: 'object',
          additionalProperties: false,
          required: %w[normalization],
          properties: {
            normalization: {
              type: 'string',
              description: 'The text formatting',
              enum: %w[capitalize downcase upcase]
            }
          }
        },
        other_than: {
          type: 'object',
          additionalProperties: false,
          required: %w[other_than],
          properties: {
            other_than: {
              type: 'number',
              description: 'The number should be other than'
            }
          }
        },
        precision: {
          type: 'object',
          additionalProperties: false,
          required: %w[precision],
          properties: {
            precision: {
              type: 'number',
              description: 'The number of digits in the number'
            }
          }
        },
        readonly: {
          type: 'object',
          additionalProperties: false,
          required: %w[readonly],
          properties: {
            readonly: {
              type: 'boolean',
              description: 'Is the attribute readonly or not'
            }
          }
        },
        required: {
          type: 'object',
          additionalProperties: false,
          required: %w[required],
          properties: {
            required: {
              type: 'boolean',
              description: 'Is the attribute required or not'
            }
          }
        },
        scale: {
          type: 'object',
          additionalProperties: false,
          required: %w[scale],
          properties: {
            scale: {
              type: 'number',
              description: 'The number of digits following the decimal point in the number'
            }
          }
        },
        schemes: {
          type: 'object',
          additionalProperties: false,
          required: %w[schemes],
          properties: {
            schemes: {
              type: 'array',
              description: 'The URL schemes',
              items: {
                type: 'string',
                enum: %w[http https]
              }
            }
          }
        },
        separator: {
          type: 'object',
          additionalProperties: false,
          required: %w[separator],
          properties: {
            separator: {
              type: 'string',
              description: 'The number decimal separator',
              enum: %w[, .]
            }
          }
        },
        size: {
          type: 'object',
          additionalProperties: false,
          required: %w[size],
          properties: {
            size: {
              type: 'number',
              description: 'The maximum size of the attachment in megabytes'
            }
          }
        },
        start_date: {
          type: 'object',
          additionalProperties: false,
          required: %w[start_date],
          properties: {
            start_date: {
              type: 'boolean',
              description: 'Is the date the start of a calendar range'
            }
          }
        },
        translated: {
          type: 'object',
          additionalProperties: false,
          required: %w[translated],
          properties: {
            translated: {
              type: 'boolean',
              description: 'Is the text translated or not'
            }
          }
        },
        unique: {
          type: 'object',
          additionalProperties: false,
          required: %w[unique],
          properties: {
            unique: {
              type: 'boolean',
              description: 'Is the text unique or not'
            }
          }
        },
        unit: {
          type: 'object',
          additionalProperties: false,
          required: %w[unit],
          properties: {
            unit: {
              type: 'string',
              description: 'The number unit'
            }
          }
        },
        values: {
          type: 'object',
          additionalProperties: false,
          required: %w[values],
          properties: {
            values: {
              type: 'array',
              description: 'The enumeration values',
              items: {
                type: 'string'
              }
            }
          }
        },
        width: {
          type: 'object',
          additionalProperties: false,
          required: %w[width],
          properties: {
            width: {
              type: 'number',
              description: 'The width of the image in pixels'
            }
          }
        },
        icon: {
          type: 'string',
          description: 'An icon which represents the entity or event',
          enum: %w[box users]
        },
        name: {
          type: 'string',
          description: <<~TEXT.squish
            The name is unique, in snake case, in english and without id suffix. The name must not be among #{ActiveRecord::AttributeMethods.dangerous_attribute_methods.dup.merge(Schematics::Behaviours::Nameable::NAME_DENYLIST).merge(Schematics::Trackable::DENYLIST).to_a.map(&:to_s).to_sentence}
          TEXT
        },
        address: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a postal address',
              enum: %w[address]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/normalization' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/limit' },
                { '$ref': '#/$defs/length' },
                { '$ref': '#/$defs/unique' },
                { '$ref': '#/$defs/case_insensitive' }
              ],
              additionalProperties: false
            }
          }
        },
        array: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents an array of values',
              enum: %w[array]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/translated' }
              ],
              additionalProperties: false
            }
          }
        },
        attachment: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents an attachment',
              enum: %w[attachment]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/size' },
                { '$ref': '#/$defs/aspect_ratio' },
                { '$ref': '#/$defs/width' },
                { '$ref': '#/$defs/height' },
                { '$ref': '#/$defs/content_type' }
              ],
              additionalProperties: false
            }
          }
        },
        attachments: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a set of attachments',
              enum: %w[attachments]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/size' },
                { '$ref': '#/$defs/aspect_ratio' },
                { '$ref': '#/$defs/width' },
                { '$ref': '#/$defs/height' },
                { '$ref': '#/$defs/content_type' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/max' }
              ],
              additionalProperties: false
            }
          }
        },
        belongs_to: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'A one-to-many association',
              enum: %w[belongs_to]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/inverse_association_type' }
              ],
              additionalProperties: false
            }
          }
        },
        boolean: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a boolean',
              enum: %w[boolean]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/acceptance' }
              ],
              additionalProperties: false
            }
          }
        },
        byte: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a byte',
              enum: %w[byte]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' },
                { '$ref': '#/$defs/precision' },
                { '$ref': '#/$defs/separator' },
                { '$ref': '#/$defs/delimiter' }
              ],
              additionalProperties: false
            }
          }
        },
        code: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a source code',
              enum: %w[code]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/translated' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/limit' },
                { '$ref': '#/$defs/length' },
                { '$ref': '#/$defs/language' }
              ],
              additionalProperties: false
            }
          }
        },
        color: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents an hexadecimal color',
              enum: %w[color]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/limit' },
                { '$ref': '#/$defs/length' },
                { '$ref': '#/$defs/unique' },
                { '$ref': '#/$defs/case_insensitive' }
              ],
              additionalProperties: false
            }
          }
        },
        country: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a country name',
              enum: %w[country]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/unique' }
              ],
              additionalProperties: false
            }
          }
        },
        currency: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a currency symbol',
              enum: %w[currency]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' },
                { '$ref': '#/$defs/unit' },
                { '$ref': '#/$defs/precision' },
                { '$ref': '#/$defs/separator' },
                { '$ref': '#/$defs/delimiter' }
              ],
              additionalProperties: false
            }
          }
        },
        date: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a date without time',
              enum: %w[date]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' },
                { '$ref': '#/$defs/start_date' },
                { '$ref': '#/$defs/end_date' }
              ],
              additionalProperties: false
            }
          }
        },
        datetime: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a date with a time',
              enum: %w[datetime]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' },
                { '$ref': '#/$defs/start_date' },
                { '$ref': '#/$defs/end_date' }
              ],
              additionalProperties: false
            }
          }
        },
        decimal: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a decimal',
              enum: %w[decimal]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' },
                { '$ref': '#/$defs/auto_increment' },
                { '$ref': '#/$defs/unit' },
                { '$ref': '#/$defs/precision' },
                { '$ref': '#/$defs/scale' },
                { '$ref': '#/$defs/separator' },
                { '$ref': '#/$defs/delimiter' }
              ],
              additionalProperties: false
            }
          }
        },
        digest: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a password',
              enum: %w[digest]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/confirm' },
                { '$ref': '#/$defs/min' }
              ],
              additionalProperties: false
            }
          }
        },
        duration: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a duration',
              enum: %w[duration]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' },
                { '$ref': '#/$defs/unit' }
              ],
              additionalProperties: false
            }
          }
        },
        email: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents an email address',
              enum: %w[email]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/limit' },
                { '$ref': '#/$defs/length' },
                { '$ref': '#/$defs/unique' }
              ],
              additionalProperties: false
            }
          }
        },
        enum: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents an enumeration',
              enum: %w[enum]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/values' }
              ],
              additionalProperties: false
            }
          }
        },
        flag: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents an enumeration with multiple choices',
              enum: %w[flag]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/values' }
              ],
              additionalProperties: false
            }
          }
        },
        float: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a float number',
              enum: %w[float]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' },
                { '$ref': '#/$defs/auto_increment' },
                { '$ref': '#/$defs/unit' },
                { '$ref': '#/$defs/precision' },
                { '$ref': '#/$defs/separator' },
                { '$ref': '#/$defs/delimiter' }
              ],
              additionalProperties: false
            }
          }
        },
        integer: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents an integer',
              enum: %w[integer]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' },
                { '$ref': '#/$defs/auto_increment' },
                { '$ref': '#/$defs/unit' }
              ],
              additionalProperties: false
            }
          }
        },
        ip: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents an IP address',
              enum: %w[ip]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/limit' },
                { '$ref': '#/$defs/length' },
                { '$ref': '#/$defs/unique' },
                { '$ref': '#/$defs/case_insensitive' }
              ],
              additionalProperties: false
            }
          }
        },
        jsonb: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a JSON value',
              enum: %w[jsonb]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/translated' }
              ],
              additionalProperties: false
            }
          }
        },
        mime: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a MIME type',
              enum: %w[mime]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/unique' }
              ],
              additionalProperties: false
            }
          }
        },
        one_time_password: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a One Time Password',
              enum: %w[one_time_password]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' }
              ],
              additionalProperties: false
            }
          }
        },
        percentage: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a percentage',
              enum: %w[percentage]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' },
                { '$ref': '#/$defs/precision' },
                { '$ref': '#/$defs/separator' },
                { '$ref': '#/$defs/delimiter' }
              ],
              additionalProperties: false
            }
          }
        },
        phone: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a phone number',
              enum: %w[phone]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/limit' },
                { '$ref': '#/$defs/length' },
                { '$ref': '#/$defs/unique' },
                { '$ref': '#/$defs/case_insensitive' }
              ],
              additionalProperties: false
            }
          }
        },
        rating: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a rating',
              enum: %w[rating]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' },
                { '$ref': '#/$defs/precision' },
                { '$ref': '#/$defs/separator' },
                { '$ref': '#/$defs/delimiter' }
              ],
              additionalProperties: false
            }
          }
        },
        response_code: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a HTTP response code',
              enum: %w[response_code]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' }
              ],
              additionalProperties: false
            }
          }
        },
        rich_text: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a Rich Text',
              enum: %w[rich_text]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/translated' }
              ],
              additionalProperties: false
            }
          }
        },
        secret: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a secret',
              enum: %w[secret]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/normalization' }
              ],
              additionalProperties: false
            }
          }
        },
        state_machine: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a state machine',
              enum: %w[state_machine]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/values' },
                { '$ref': '#/$defs/events' }
              ],
              additionalProperties: false
            }
          }
        },
        string: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a string',
              enum: %w[string]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/translated' },
                { '$ref': '#/$defs/normalization' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/limit' },
                { '$ref': '#/$defs/length' },
                { '$ref': '#/$defs/unique' },
                { '$ref': '#/$defs/case_insensitive' }
              ],
              additionalProperties: false
            }
          }
        },
        text: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a text',
              enum: %w[text]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/translated' },
                { '$ref': '#/$defs/normalization' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/limit' },
                { '$ref': '#/$defs/length' }
              ],
              additionalProperties: false
            }
          }
        },
        time: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a time',
              enum: %w[time]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/greater_than' },
                { '$ref': '#/$defs/greater_than_or_equal_to' },
                { '$ref': '#/$defs/equal_to' },
                { '$ref': '#/$defs/less_than' },
                { '$ref': '#/$defs/less_than_or_equal_to' },
                { '$ref': '#/$defs/other_than' }
              ],
              additionalProperties: false
            }
          }
        },
        time_zone: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a time zone',
              enum: %w[time_zone]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/unique' }
              ],
              additionalProperties: false
            }
          }
        },
        token: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a token',
              enum: %w[token]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' }
              ],
              additionalProperties: false
            }
          }
        },
        url: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a URL',
              enum: %w[url]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/limit' },
                { '$ref': '#/$defs/length' },
                { '$ref': '#/$defs/unique' },
                { '$ref': '#/$defs/schemes' }
              ],
              additionalProperties: false
            }
          }
        },
        user: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents the current user',
              enum: %w[user]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/inverse_association_type' }
              ],
              additionalProperties: false
            }
          }
        },
        user_agent: {
          type: 'object',
          additionalProperties: false,
          required: %w[name type options],
          properties: {
            type: {
              type: 'string',
              description: 'An attribute which represents a user agent',
              enum: %w[user_agent]
            },
            name: { '$ref': '#/$defs/name' },
            options: {
              type: 'object',
              anyOf: [
                { '$ref': '#/$defs/required' },
                { '$ref': '#/$defs/default' },
                { '$ref': '#/$defs/readonly' },
                { '$ref': '#/$defs/min' },
                { '$ref': '#/$defs/limit' },
                { '$ref': '#/$defs/length' },
                { '$ref': '#/$defs/unique' },
                { '$ref': '#/$defs/case_insensitive' }
              ],
              additionalProperties: false
            }
          }
        }
      },
      additionalProperties: false,
      required: %w[name options attributes]
    }
  end

  before do
    allow(Mime::LOOKUP).to receive(:keys).and_return(['image/png'])
    allow(YAML)
      .to receive(:load_file)
      .with(File.expand_path('../../../lib/icons.yml', __dir__))
      .and_return(%w[box users])
  end

  its(:to_h) { is_expected.to eq(expected_hash) }
end
