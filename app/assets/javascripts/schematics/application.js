//= require jquery3
//= require popper
//= require bootstrap
//= require chartkick
//= require Chart.bundle
//= require rails.validations
//= require rails.validations.simple_form.bootstrap4
//= require pagy
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
    $('tr[data-href]').click(function(e) {
        const $target = $(e.target);
        if (!$target.is('a') && !$target.parent().is('a') && 
            !$target.hasClass('best_in_place') && !$target.parents('.best_in_place').length) {
            Turbolinks.visit($(this).data('href'));
        }
    });
    $('.card-body[data-target]').click(function(e) {
        const $target = $(e.target);
        if (!$target.is('a') && !$target.parent().is('a')) {
            $($(this).data('target')).modal('show');
        }
    });
    $('#sidebar-toggle').click(function() {
        $('.sidebar, .content').toggleClass('toggled');
        $('.sidebar .d-none').toggleClass('d-md-block');
    });
    $('input[type=search]').on('search', function(e) {
        const $target = $(e.target);
        const scope = $target.attr('name');
        const searchParams = new URLSearchParams(window.location.search);
        searchParams.delete(scope);
        Turbolinks.visit(window.location.pathname + '?' + searchParams);
    });
});

$(document).on('show.bs.modal', '.modal', function() {
    $(this).appendTo('body');
});
