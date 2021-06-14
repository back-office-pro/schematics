//= require stimulus/dist/stimulus.umd
//= require regenerator-runtime/runtime
//= require notification_center/component
//= require sidebar/component
//= require switch_theme/component
//= require search_bar/component
//= require filter/typeahead/component

/* global Stimulus, fetch, SwitchThemeController, NotificationCenterController, SidebarController, SearchBarController, TypeaheadController */

window.fetchAPI = (url, method = 'GET', data) => {
  const csrfToken = document.querySelector("[name='csrf-token']").content
  const options = {
    method: method,
    body: data && JSON.stringify(data),
    headers: {
      'X-CSRF-Token': csrfToken,
      'Content-Type': 'application/json',
      Accept: 'application/json'
    }
  }
  return fetch(url, options)
}

const application = Stimulus.Application.start()

application.register('switchTheme', SwitchThemeController)
application.register('notificationCenter', NotificationCenterController)
application.register('sidebar', SidebarController)
application.register('searchBar', SearchBarController)
application.register('typeahead', TypeaheadController)
