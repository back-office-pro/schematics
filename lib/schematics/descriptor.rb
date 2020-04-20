module Schematics
  class Descriptor
    def initialize(name)
      @name = name || 'id'
    end

    def to_s
      @name
    end

    def to_str
      <<~RUBY
        friendly_id :#{@name}, use: [:slugged, :finders]
        alias_attribute :to_s, :#{@name}
      RUBY
    end

    def serializer_class
      descriptor = @name
      Class.new ActiveModel::Serializer do
        attribute :id
        attribute descriptor if descriptor != 'id'
      end
    end
  end
end
