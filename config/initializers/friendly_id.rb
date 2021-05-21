# frozen_string_literal: true

FriendlyId.defaults do |config|
  config.use :reserved
  config.reserved_words = %w[new nouveau edit editer delete supprimer]
  config.treat_reserved_as_conflict = true
  config.use :finders
  config.use :history
  config.use :slugged
  config.use Module.new do
    def should_generate_new_friendly_id?
      true
    end
  end
end
