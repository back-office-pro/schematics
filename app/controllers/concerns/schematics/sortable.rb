module Schematics
  module Sortable
    extend ActiveSupport::Concern

    def sorting_params
      return { created_at: { order: :desc, unmapped_type: 'long' } } if params[:sort].nil?
      ordering = {}
      sort_order = { '+' => :asc, '-' => :desc }
      sorted_params = params[:sort].split(',')
      sorted_params.each do |sorted_param|
        sort_sign = sorted_param =~ /\A[+-]/ ? sorted_param.slice!(0) : '+'
        ordering[sorted_param] = { order: sort_order[sort_sign] }
      end
      ordering
    end
  end
end
