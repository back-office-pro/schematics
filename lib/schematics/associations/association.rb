module Schematics
  module Associations
    class Association
      include Renderable
      attr_accessor :belongs_to
      delegate :entity, :required?, to: :@belongs_to
      delegate :descriptor, to: :entity

      def initialize(belongs_to)
        @belongs_to = belongs_to
      end

      def type
        self.class.name.demodulize.underscore
      end

      def name
        belongs_to.inverse_association_name
      end

      def class_name
        entity.type.camelize
      end

      def filter_scope
        <<~RUBY
          scope :by_#{name}, ->
        RUBY
      end

      def sort_scope
        <<~RUBY
          scope :sort_by_#{name}, ->
        RUBY
      end

      def has_filter_scope
        <<~RUBY
          has_scope :by_#{name}, only: :index
        RUBY
      end

      def has_sort_scope
        <<~RUBY
          has_scope :sort_by_#{name}, only: :index
        RUBY
      end

      def to_str
        <<~RUBY
          #{type} :#{name},
                  class_name: '#{class_name}',
                  foreign_key: '#{belongs_to.column_name}'
        RUBY
      end

      def icon
        :link
      end
    end
  end
end
