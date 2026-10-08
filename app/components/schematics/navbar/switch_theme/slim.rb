# frozen_string_literal: true

Schematics::Navbar::SwitchTheme::SLIM = <<~SLIM
  li.nav-item.d-flex.align-items-center.px-2.ms-2.bg-body-secondary.rounded.btn-transparent data-controller='switch-theme'
    a.nav-link.switch-theme.dark {
      role='button'
      data-action='click->switch-theme#switchTheme:stop'
      data-switch-theme-theme-param='dark'
    }
      = fa_icon :moon, class: 'fa-lg'
    a.nav-link.switch-theme.light {
      role='button'
      data-action='click->switch-theme#switchTheme:stop'
      data-switch-theme-theme-param='light'
    }
      = fa_icon :lightbulb, class: 'fa-lg'
SLIM
