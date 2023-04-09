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

    # Column Fallback
    #
    # Uncomment line below to fallback to original column. You can pass
    # +column_fallback: true+ to +translates+ to return original column on
    # default locale, or pass +column_fallback: [:en, :de]+ to +translates+
    # to return original column for those locales or pass
    # +column_fallback: ->(locale) { ... }+ to +translates to evaluate which
    # locales to return original column for.
    # column_fallback
    #
    # Or uncomment this line to enable column fallback with a global default.
    # column_fallback true

    # Fallbacks
    #
    # Uncomment line below to enable fallbacks, using +I18n.fallbacks+.
    # fallbacks
    #
    # Or uncomment this line to enable fallbacks with a global default.
    # fallbacks { :pt => :en }

    # Presence
    #
    # Converts blank strings to nil on reads and writes. Comment out to
    # disable.
    #
    presence

    # Default
    #
    # Set a default translation per attributes. When enabled, passing +default:
    # 'foo'+ sets a default translation string to show in case no translation is
    # present. Can also be passed a proc.
    #
    # default 'foo'

    # Fallthrough Accessors
    #
    # Uses method_missing to define locale-specific accessor methods like
    # +title_en+, +title_en=+, +title_fr+, +title_fr=+ for each translated
    # attribute. If you know what set of locales you want to support, it's
    # generally better to use Locale Accessors (or both together) since
    # +method_missing+ is very slow.  (You can use both fallthrough and locale
    # accessor plugins together without conflict.)
    #
    # fallthrough_accessors

    # Locale Accessors
    #
    # Uses +def+ to define accessor methods for a set of locales. By default uses
    # +I18n.available_locales+, but you can pass the set of locales with
    # +translates+ and/or set a global default here.
    #
    locale_accessors

    # Attribute Methods
    #
    # Adds translated attributes to +attributes+ hash, and defines methods
    # +translated_attributes+ and +untranslated_attributes+ which return hashes
    # with translated and untranslated attributes, respectively. Be aware that
    # this plugin can create conflicts with other gems.
    #
    # attribute_methods
  end
end
