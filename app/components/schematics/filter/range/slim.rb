# frozen_string_literal: true

Schematics::Filter::Range::SLIM = <<~SLIM
  .input-group.flex-nowrap
    = __filter_range_bound(field:, comparison: :gte)
    .me-2
    = __filter_range_bound(field:, comparison: :lte)
SLIM
