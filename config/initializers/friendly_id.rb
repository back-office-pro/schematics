# frozen_string_literal: true

FriendlyId.defaults do |config|
  config.use :reserved, :finders, :history, :sequentially_slugged
  config.treat_reserved_as_conflict = true
  config.reserved_words = %w[
    new
    nouveau
    edit
    editer
    delete
    supprimer
    import
    comments
    commentaires
  ]
  config.use Module.new do
    def should_generate_new_friendly_id? = true
  end
end
