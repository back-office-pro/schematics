# frozen_string_literal: true

Schematics::Footer::Network::SLIM = <<~SLIM
  span.mx-1 data-controller='network'
    = fa_icon :wifi,
              data: { controller: 'tooltip', 'network-target': 'online' },
              class: 'text-primary',
              title: t('.online')
    = fa_icon :wifi,
              data: { controller: 'tooltip', 'network-target': 'offline' },
              class: offline_css_classes,
              title: t('.offline')
SLIM
