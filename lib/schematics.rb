require 'active_support/inflector'
require 'json'
require 'csv'
require 'pagy'
require 'pagy/extras/searchkick'
require 'pagy/extras/headers'
require 'pagy/extras/bootstrap'
require 'pagy/extras/i18n'
require 'paranoia'
require 'paper_trail'
require 'rails'
require 'action_controller'
require 'binding_of_caller'
require 'searchkick'
require 'rack/attack'
require 'swagger/docs'
require 'bullet'
require 'rack/cors'
require 'swagger_ui_engine'
require 'simple_form'
require 'client_side_validations'
require 'client_side_validations/simple_form'
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
require 'active_storage_base64'
require 'json_schemer'
require 'route_translator'
require 'date_validator'
require 'google/cloud/translate'
require 'oj'
require 'active_model_serializers'
require 'acts_as_singleton'
require 'ancestry'
require 'animate-rails'
require 'title'
require 'best_in_place'
require 'jquery-ui-rails'
require 'rails-erd'
require 'bootstrap-email'
require 'interactor'
require 'cells-rails'
require 'cells-slim'
require 'json_web_token'
require 'array'
require 'string'
require 'schematics/engine'
require_relative 'swagger/docs/config'
require_relative 'active_support/test_case' if Rails.env.test?

module Schematics
  module Associations
    autoload :AssociationThrough, 'schematics/associations/association_through'
    autoload :Association,        'schematics/associations/association'
    autoload :HasManyThrough,     'schematics/associations/has_many_through'
    autoload :HasMany,            'schematics/associations/has_many'
    autoload :HasOneThrough,      'schematics/associations/has_one_through'
    autoload :HasOne,             'schematics/associations/has_one'
  end

  module Attributes
    autoload :Association, 'schematics/attributes/association'
    autoload :Attachment,  'schematics/attributes/attachment'
    autoload :Attachments, 'schematics/attributes/attachments'
    autoload :Attribute,   'schematics/attributes/attribute'
    autoload :BelongsTo,   'schematics/attributes/belongs_to'
    autoload :Boolean,     'schematics/attributes/boolean'
    autoload :Date,        'schematics/attributes/date'
    autoload :Datetime,    'schematics/attributes/datetime'
    autoload :Decimal,     'schematics/attributes/decimal'
    autoload :Digest,      'schematics/attributes/digest'
    autoload :Enum,        'schematics/attributes/enum'
    autoload :Float,       'schematics/attributes/float'
    autoload :Integer,     'schematics/attributes/integer'
    autoload :References,  'schematics/attributes/references'
    autoload :RichText,    'schematics/attributes/rich_text'
    autoload :String,      'schematics/attributes/string'
    autoload :Text,        'schematics/attributes/text'
    autoload :Time,        'schematics/attributes/time'
    autoload :Timestamp,   'schematics/attributes/timestamp'
    autoload :Token,       'schematics/attributes/token'
  end

  module Behaviours
    autoload :Editable,    'schematics/behaviours/editable'
    autoload :Fillable,    'schematics/behaviours/fillable'
    autoload :Preloadable, 'schematics/behaviours/preloadable'
    autoload :Rangeable,   'schematics/behaviours/rangeable'
    autoload :Renderable,  'schematics/behaviours/renderable'
    autoload :Searchable,  'schematics/behaviours/searchable'
  end

  module Entities
    autoload :Descriptor, 'schematics/entities/descriptor'
    autoload :Entity,     'schematics/entities/entity'
    autoload :Singleton,  'schematics/entities/singleton'
    autoload :Tree,       'schematics/entities/tree'
  end

  module Graphics
    module Axes
      autoload :Axis, 'schematics/graphics/axes/axis'
      autoload :X,    'schematics/graphics/axes/x'
      autoload :Y,    'schematics/graphics/axes/y'
    end
    autoload :Chart, 'schematics/graphics/chart'
    autoload :Stat,  'schematics/graphics/stat'
  end

  module Patches
    module Rails
      module Generators
        autoload :GeneratedAttribute, 'schematics/patches/rails/generators/generated_attribute'
      end
    end
  end

  module Tests
    autoload :Controller, 'schematics/tests/controller'
    autoload :Dummy,      'schematics/tests/dummy'
    autoload :Model,      'schematics/tests/model'
    autoload :System,     'schematics/tests/system'
  end

  module Tokens
    autoload :Number,      'schematics/tokens/number'
    autoload :Operator,    'schematics/tokens/operator'
    autoload :Parenthesis, 'schematics/tokens/parenthesis'
    autoload :Reference,   'schematics/tokens/reference'
    autoload :String,      'schematics/tokens/string'
    autoload :Token,       'schematics/tokens/token'
    autoload :Tokenizer,   'schematics/tokens/tokenizer'
    autoload :Variable,    'schematics/tokens/variable'
    autoload :Whitespace,  'schematics/tokens/whitespace'
  end

  module Virtuals
    module Errors
      autoload :NameError, 'schematics/virtuals/errors/name_error'
      autoload :TypeError, 'schematics/virtuals/errors/type_error'
    end
    autoload :Calculation,   'schematics/virtuals/calculation'
    autoload :Concatenation, 'schematics/virtuals/concatenation'
    autoload :Virtual,       'schematics/virtuals/virtual'
  end

  autoload :Schema, 'schematics/schema'

  SCHEMA = Schema.instance
end
