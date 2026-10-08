# frozen_string_literal: true

Schematics::Chart::Helper::SLIM = <<~SLIM
  = helpers.public_send type,
                        data_source,
                        id:,
                        xtitle:,
                        ytitle:,
                        suffix:,
                        prefix:,
                        colors:,
                        decimal:,
                        thousands:,
                        precision:,
                        bytes:,
                        empty:,
                        height:,
                        download: { filename: },
                        dataset: { borderWidth: border_width },
                        library: { animation: }
SLIM
