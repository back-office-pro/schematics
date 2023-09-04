# frozen_string_literal: true

module UUID
  module Shortener
    module_function

    ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    BASE = ALPHABET.length
    ALPHABET_HASH = ALPHABET
                    .each_char
                    .with_index
                    .each_with_object({}) { |(key, value), hash| hash[key] = value }
                    .freeze

    def shorten(uuid)
      return unless uuid

      num = uuid.tr('-', '').to_i(16)
      return '0' if num.zero?
      return if num.negative?

      str = ''
      while num.positive?
        str = ALPHABET[num % BASE] + str
        num /= BASE
      end
      str
    end

    def expand(suid)
      num = index = 0
      len = suid.length - 1
      while index < suid.length
        pow = BASE**(len - index)
        num += ALPHABET_HASH[suid[index]] * pow
        index += 1
      end
      num.to_s(16).rjust(32, '0').unpack('A8A4A4A4A12').join('-')
    rescue StandardError
      suid
    end
  end
end
