# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Mobility.configure do
  plugins do
    backend :key_value
    active_record
    ransack
    reader
    writer
    backend_reader
    query
    cache
    dirty
    column_fallback true
    fallbacks
    presence
    locale_accessors
    attribute_methods
  end
end
