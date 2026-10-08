# frozen_string_literal: true

Schematics::ThemeCustomStylesheet::SLIM = <<~SLIM
  css [nonce=content_security_policy_nonce]:
    :root {
      --bs-primary: \#{theme_color};
      --bs-primary-darken: \#{theme_color_darken};
      --bs-primary-rgb: \#{theme_color_rgb};
      --bs-link-color: \#{theme_color};
      --bs-link-color-rgb: \#{theme_color_rgb};
      --bs-link-hover-color: \#{theme_color_darken};
      --bs-link-hover-color-rgb: \#{theme_color_darken_rgb};
    }

    input {
      accent-color: \#{theme_color};
    }

    .btn-primary {
      --bs-btn-bg: \#{theme_color};
      --bs-btn-border-color: \#{theme_color};
      --bs-btn-hover-bg: \#{theme_color_darken};
      --bs-btn-hover-border-color:\#{theme_color_darken};
      --bs-btn-active-bg: \#{theme_color_darken};
      --bs-btn-active-border-color: \#{theme_color_darken};
      --bs-btn-disabled-bg: \#{theme_color};
      --bs-btn-disabled-border-color: \#{theme_color};
      --bs-btn-focus-shadow-rgb: \#{theme_color_rgb};
    }

    .pagination {
      --bs-pagination-active-bg: \#{theme_color};
      --bs-pagination-active-border-color: \#{theme_color};
    }

    .progress {
      --bs-progress-bar-bg: \#{theme_color};
    }

    .list-group {
      --bs-list-group-active-bg: \#{theme_color};
      --bs-list-group-active-border-color: \#{theme_color};
    }

    .nav-pills .nav-link.active {
      --bs-nav-pills-link-active-bg: \#{theme_color};
    }
SLIM
