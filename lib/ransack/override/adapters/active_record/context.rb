# frozen_string_literal: true

# TODO: remove when https://github.com/activerecord-hackery/ransack/pull/1493 is released
module Ransack
  module Override
    module Adapters
      module ActiveRecord
        module Context
          def join_sources
            base, joins = begin
              alias_tracker = @object.alias_tracker
              constraints = @join_dependency.join_constraints(
                @object.joins_values,
                alias_tracker,
                @object.references_values
              )

              [
                Arel::SelectManager.new(@object.table),
                constraints
              ]
            end
            joins.each do |aliased_join|
              base.from(aliased_join)
            end
            base.join_sources
          end

          # :reek:FeatureEnvy
          def build_joins(relation) # rubocop:disable Metrics/CyclomaticComplexity
            buckets = relation.joins_values + relation.left_outer_joins_values
            buckets = buckets.group_by do |join|
              case join
              when String
                :string_join
              when Hash, Symbol, Array
                :association_join
              when Polyamorous::JoinDependency, Polyamorous::JoinAssociation
                :stashed_join
              when Arel::Nodes::Join
                :join_node
              else
                raise 'unknown class: %s' % join.class.name # rubocop:disable Style/FormatString
              end
            end
            buckets.default = []
            association_joins = buckets[:association_join]
            join_nodes = buckets[:join_node].uniq
            string_joins = buckets[:string_join].map(&:strip)
            string_joins.uniq!

            join_list = join_nodes + convert_join_strings_to_ast(relation.table, string_joins)

            alias_tracker = relation.alias_tracker(join_list)

            join_dependency = Polyamorous::JoinDependency.new(
              relation.klass,
              relation.table,
              association_joins,
              Arel::Nodes::OuterJoin
            )
            join_dependency.instance_variable_set(:@alias_tracker, alias_tracker)
            join_nodes.each do |join|
              join_dependency.send(:alias_tracker).aliases[join.left.name.downcase] = 1 # rubocop:disable Style/Send
            end
            join_dependency
          end
        end
      end
    end
  end
end
