$(document).on('turbolinks:load', function() {
    $('#sidebar-toggle').on('click', function() {
        $('.sidebar, .content').toggleClass('toggled');
        $('.sidebar .d-none').toggleClass('d-md-block');
        $.post('/dashboard/toggle_sidebar');
    });
});
