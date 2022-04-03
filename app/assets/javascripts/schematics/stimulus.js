import { Application } from '../@hotwired/stimulus/dist/stimulus'
import { SwitchThemeController } from '../switch_theme/component'
import { NotificationCenterController } from '../notification_center/component'
import { SidebarController } from '../sidebar/component'
import { SearchBarController } from '../search_bar/component'
import { TypeaheadController } from '../filter/typeahead/component'
import { GenerateFileInBackgroundController } from '../button/generate_file_in_background/component'
import { ViewerSettingsController } from '../viewer/settings/component'
import { ComparisonController } from '../viewer/component'

/* global Stimulus */

window.Stimulus = Application.start()

Stimulus.register('switch-theme', SwitchThemeController)
Stimulus.register('notification-center', NotificationCenterController)
Stimulus.register('sidebar', SidebarController)
Stimulus.register('search-bar', SearchBarController)
Stimulus.register('typeahead', TypeaheadController)
Stimulus.register('generate-file-in-background', GenerateFileInBackgroundController)
Stimulus.register('viewer-settings', ViewerSettingsController)
Stimulus.register('comparison', ComparisonController)
