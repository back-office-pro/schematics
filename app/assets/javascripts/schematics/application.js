//= require jquery3
//= require popper
//= require bootstrap
//= require chartkick
//= require Chart.bundle
//= require rails.validations
//= require rails.validations.simple_form.bootstrap4
//= require_tree .

$(document).on('turbolinks:load', function() {
    $('.content .container-fluid').addClass('animated slideInDown');
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
        const target = $(e.target);
        if (!target.is('a') && !target.parent().is('a')) {
            window.location = $(this).data('href');
        }
    });
    $('#sidebar-toggle').click(function() {
        $('.sidebar, .content').toggleClass('toggled');
        $('.sidebar .d-none').toggleClass('d-md-block');
    });
});
