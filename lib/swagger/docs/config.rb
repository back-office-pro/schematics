module Swagger
  module Docs
    class Config
      class << self
        def base_applications
          [Rails.application, Schematics::Engine]
        end
      end
    end
  end
end
