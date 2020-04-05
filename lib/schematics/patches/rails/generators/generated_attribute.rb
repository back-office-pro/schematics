module Schematics
  module Patches
    module Rails
      module Generators
        module GeneratedAttribute
          def default
            case type
            when :token
              SecureRandom.base58
            when :string
              if attr_options[:email]
                "#{SecureRandom.base58}@#{SecureRandom.base58}.com"
              elsif attr_options[:phone]
                Array.new(10) { rand(10) }
              elsif attr_options[:url]
                "www.#{SecureRandom.base58}.com"
              elsif has_uniq_index?
                SecureRandom.base58
              else
                super
              end
            else
              super
            end
          end

          def required?
            attr_options[:required]
          end

          def has_index?
            !virtual? && !token? && !password_digest?
          end

          def options_for_migration
            options = super.except(:required, :type, :email, :url, :phone)
            if options.key?(:foreign_key) && attr_options.key?(:type)
              options[:foreign_key] = { to_table: attr_options[:type].pluralize.to_sym }
            end
            # TODO remove when https://github.com/rails/rails/pull/37583 is published
            # Fix this issue: https://github.com/rails/rails/issues/23422
            options[:type] = :uuid if reference?
            options
          end

          def parse(column_definition)
            name, type, *options = column_definition.split(":")
            options = Hash[*options].symbolize_keys
            has_index = 'uniq' if options[:unique]
            new(name, type.to_sym, has_index, eval_options(options, type))
          end

          private

          def eval_options(options, type)
            options[:limit]       = options[:limit].to_i if options.key?(:limit)
            options[:precision]   = options[:precision].to_i if options.key?(:precision)
            options[:scale]       = options[:scale].to_i if options.key?(:scale)
            options[:polymorphic] = options[:polymorphic] === "true" if options.key?(:polymorphic)
            if options.key?(:default)
              options[:default] = case type.to_sym
                                  when :integer then options[:default].to_i
                                  when :float   then options[:default].to_f
                                  when :boolean then options[:default] === "true"
                                  else
                                    options[:default].to_s
                                  end
            end
            options.except(:unique)
          end
        end
      end
    end
  end
end
