FriendlyId.defaults do |config|
  config.use :reserved
  config.reserved_words = %w(
    new edit index session login logout users
    admin stylesheets assets javascripts images
  )
  config.use :finders
  config.use :history
  config.use :slugged
  config.use Module.new {
    def should_generate_new_friendly_id?
      true
    end
  }
end
