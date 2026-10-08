# frozen_string_literal: true

Schematics::ChartPlaceholder::SLIM = <<~SLIM
  .chart id='%{id}' style='height: %{height}; width: %{width};'
    = __placeholder
SLIM
