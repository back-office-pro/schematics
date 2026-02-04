# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module OpenAI
  class StructuredOutput
    OPTIONS_DENYLIST = %i[
      Actions
      CollectionOption
      Descriptor
      EnumValue
      Option
      Icon
      StateMachineEvent
      Wrapper
    ].freeze

    def to_h = {
      type: 'object',
      properties: {
        **entity_name_def,
        **entity_options_def,
        attributes: { type: 'array', items: { anyOf: attribute_refs } }
      },
      '$defs': option_defs.merge(attribute_defs, icon_def, attribute_name_def),
      additionalProperties: false,
      required: %w[name options attributes]
    }

    private

    def entity_name_def = {
      name: {
        type: 'string',
        description: <<~TEXT.squish
          The unique entity name at singular, in snake case and in english. The name must not be among #{forbidden_entity_names}
        TEXT
      }
    }

    def forbidden_entity_names = Schematics::Schema
      .new
      .entities
      .map(&:name)
      .concat(Schematics::Entities::Entity::NAME_DENYLIST)
      .to_sentence

    def entity_options_def = {
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
      }
    }

    def attribute_refs = Schematics::Attributes::Attribute
      .collection
      .map(&:type)
      .sort
      .map { { '$ref': "#/$defs/#{_1}" } }

    def option_defs = Schematics::Options
      .constants
      .excluding(OPTIONS_DENYLIST)
      .map(&Schematics::Options.method(:const_get))
      .reject(&:hidden?)
      .map(&:to_openai_schema)
      .reduce(&:merge)

    def attribute_defs = Schematics::Attributes::Attribute
      .collection
      .each_with_object(entity:)
      .map(&:new)
      .map(&:to_openai_schema)
      .reduce(&:merge)

    def entity = Schematics::Entities::Entity.new

    def icon_def = Schematics::Options::Icon
      .to_openai_schema
      .dig(:icon, :properties)

    def attribute_name_def = {
      name: {
        type: 'string',
        description: <<~TEXT.squish
          The name is unique, in snake case, in english and without id suffix. The name must not be among #{forbidden_attribute_names}
        TEXT
      }
    }

    def forbidden_attribute_names = ActiveRecord::AttributeMethods
      .dangerous_attribute_methods
      .dup
      .merge(Schematics::Behaviours::Nameable::NAME_DENYLIST)
      .merge(Schematics::Trackable::DENYLIST)
      .to_a
      .map(&:to_s)
      .to_sentence
  end
end
