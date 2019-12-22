require 'active_support/inflector'
require 'json'
require 'csv'
require 'pagy'
require 'pagy/extras/headers'
require 'pagy/extras/bootstrap'
require 'paranoia'
require 'paper_trail'
require 'rails'
require 'action_controller'
require 'has_scope'
require 'rack/attack'
require 'swagger/docs'
require 'olive_branch'
require 'bullet'
require 'rack/cors'
require 'swagger_ui_engine'
require 'simple_form'
require 'bootstrap'
require 'bootswatch'
require 'wicked_pdf'
require 'slim'
require 'rails-i18n'
require 'font_awesome5_rails'
require 'friendly_id'
require 'jquery-rails'
require 'jwt'
require 'phonelib'
require 'valid_email'
require 'validate_url'
require 'active_storage_validations'
require 'mini_magick'
require 'active_link_to'
require 'loaf'
require 'twitter-typeahead-rails'
require 'groupdate'
require 'chartkick'
require 'humanize'
require 'schematics/engine'
require 'schematics/array'

module Schematics
  autoload :Chart,        'schematics/chart'
  autoload :Schema,       'schematics/schema'
  autoload :Stat,         'schematics/stat'
  autoload :Entity,       'schematics/entity'
  autoload :JsonWebToken, 'schematics/json_web_token'
  autoload :Renderable,   'schematics/renderable'

  module Associations
    autoload :Association,        'schematics/associations/association'
    autoload :AssociationThrough, 'schematics/associations/association_through'
    autoload :HasManyThrough,     'schematics/associations/has_many_through'
    autoload :HasMany,            'schematics/associations/has_many'
    autoload :HasOneThrough,      'schematics/associations/has_one_through'
    autoload :HasOne,             'schematics/associations/has_one'
  end

  module Attributes
    autoload :Attachment,   'schematics/attributes/attachment'
    autoload :Attachments,  'schematics/attributes/attachments'
    autoload :Attribute,    'schematics/attributes/attribute'
    autoload :BelongsTo,    'schematics/attributes/belongs_to'
    autoload :Boolean,      'schematics/attributes/boolean'
    autoload :Date,         'schematics/attributes/date'
    autoload :Datetime,     'schematics/attributes/datetime'
    autoload :Decimal,      'schematics/attributes/decimal'
    autoload :Digest,       'schematics/attributes/digest'
    autoload :Enum,         'schematics/attributes/enum'
    autoload :Factory,      'schematics/attributes/factory'
    autoload :Float,        'schematics/attributes/float'
    autoload :Integer,      'schematics/attributes/integer'
    autoload :References,   'schematics/attributes/references'
    autoload :RichText,     'schematics/attributes/rich_text'
    autoload :String,       'schematics/attributes/string'
    autoload :Text,         'schematics/attributes/text'
    autoload :Time,         'schematics/attributes/time'
    autoload :Timestamp,    'schematics/attributes/timestamp'
    autoload :Token,        'schematics/attributes/token'
  end

  module Patches
    module Rails
      module Generators
        autoload :Actions,            'schematics/patches/rails/generators/actions'
        autoload :GeneratedAttribute, 'schematics/patches/rails/generators/generated_attribute'
      end
    end
    module ActiveRecord
      module ConnectionAdapters
        autoload :TableDefinition, 'schematics/patches/active_record/connection_adapters/table_definition'
      end
    end
  end

  module Serializers
    autoload :CSV,        'schematics/serializers/csv'
    autoload :JSON,       'schematics/serializers/json'
    autoload :Serializer, 'schematics/serializers/serializer'
  end

  module Tests
    autoload :Controller, 'schematics/tests/controller'
    autoload :Model,      'schematics/tests/model'
    autoload :System,     'schematics/tests/system'
  end
  
  module Tokens
    autoload :Number,       'schematics/tokens/number'
    autoload :Operator,     'schematics/tokens/operator'
    autoload :Parenthesis,  'schematics/tokens/parenthesis'
    autoload :Reference,    'schematics/tokens/reference'
    autoload :String,       'schematics/tokens/string'
    autoload :Token,        'schematics/tokens/token'
    autoload :Tokenizer,    'schematics/tokens/tokenizer'
    autoload :Variable,     'schematics/tokens/variable'
    autoload :Whitespace,   'schematics/tokens/whitespace'
  end

  module Virtuals
    autoload :Calculation,    'schematics/virtuals/calculation'
    autoload :Concatenation,  'schematics/virtuals/concatenation'
    autoload :Factory,        'schematics/virtuals/factory'
    autoload :Virtual,        'schematics/virtuals/virtual'
  end

  SCHEMA = Schema.new('/Users/max/bitbucket/schematics/schema.json').freeze
end
