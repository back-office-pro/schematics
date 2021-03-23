//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require bootstrap/dist/js/bootstrap.bundle
//= require sweetalert2/dist/sweetalert2
//= require sweet-alert2-rails
//= require pagy
//= require font_awesome5
//= require rails-timeago
//= require locales/jquery.timeago.fr
//= require_tree .

$(document).on('turbolinks:load', function() {
    Pagy.init();
    $('.toast').toast({ delay: 5000 }).toast('show');
    $('[data-toggle="tooltip"]').tooltip();
    $('.custom-file-input').on('change', function () {
        $(this).
            siblings('.custom-file-label').
            addClass('selected').
            html(Array.from($(this).get(0).files).map(_ => _.name).join(', '));
    });
    $('form.form-inline').on('submit', function() {
        return $(this).find(':input').filter(function() { return !this.value; }).attr('disabled', true);
    });
    $('*[data-href]').on('click', function(e) {
        const $target = $(e.target);
        if (!$target.is('a') && !$target.parent().is('a') && 
            !$target.hasClass('best_in_place') && !$target.parents('.best_in_place').length) {
            Turbolinks.visit($(this).data('href'));
        }
    });
    $('.card-body[data-target]').on('click', function(e) {
        const $target = $(e.target);
        if (!$target.is('a') && !$target.parent().is('a')) {
            $($(this).data('target')).modal('show');
        }
    });
    $('#sidebar-toggle').on('click', function() {
        $('.sidebar, .content').toggleClass('toggled');
        $('.sidebar .d-none').toggleClass('d-md-block');
        $.post('/dashboard/toggle_sidebar');
    });
    $('input[type=search]').on('search', function(e) {
        const $target = $(e.target);
        const scope = $target.attr('name');
        const searchParams = new URLSearchParams(window.location.search);
        if (searchParams.has(scope)) {
            searchParams.delete(scope);
            Turbolinks.visit(window.location.pathname + '?' + searchParams);
        }
    });
    $('#notifications-dropdown').has('.badge.badge-danger').on('click', function() {
        $(this).find('.badge.badge-danger').fadeOut();
        $.post('/dashboard/read_notifications');
    });
    $('.switch-theme').on('click', function() {
        const $themes = $('link[href*=themes]');
        const $inactive = $themes.filter('[disabled="disabled"]');
        const $active = $themes.filter(':not([disabled="disabled"])');
        $inactive.removeAttr('disabled');
        setTimeout(() => $active.attr('disabled', 'disabled'), 10);
        $.post('/dashboard/toggle_theme');
    });
});

$(document).on('show.bs.modal', '.modal', function() {
    $(this).appendTo('body');
});

$(document).on('scroll', function() {
    $nav = $('nav.navbar');
    if ($(window).scrollTop() > 50) {
        $nav.addClass('scrolled');
    } else {
        $nav.removeClass('scrolled');
    }
});
