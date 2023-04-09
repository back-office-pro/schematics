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
    column_fallback
    presence
    locale_accessors
  end
end
