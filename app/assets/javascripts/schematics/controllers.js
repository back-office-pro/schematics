import { Application } from '../@hotwired/stimulus/dist/stimulus'
import SwitchThemeController from '../switch_theme/component'
import NotificationCenterController from '../notification_center/component'
import SidebarController from '../sidebar/component'
import SearchBarController from '../search_bar/component'
import TypeaheadController from '../filter/typeahead/component'
import GenerateFileInBackgroundController from '../button/generate_file_in_background/component'
import ViewerSettingsController from '../viewer/settings/component'
import ComparisonController from './controllers/comparison_controller'
import DropdownController from './controllers/dropdown_controller'
import TimeagoController from './controllers/timeago_controller'
import ResizableTableController from './controllers/resizable_table_controller'
import SortableController from './controllers/sortable_controller'
import FormController from './controllers/form_controller'
import ModalController from './controllers/modal_controller'

const application = Application.start()

application.register('switch-theme', SwitchThemeController)
application.register('notification-center', NotificationCenterController)
application.register('sidebar', SidebarController)
application.register('search-bar', SearchBarController)
application.register('typeahead', TypeaheadController)
application.register('generate-file-in-background', GenerateFileInBackgroundController)
application.register('viewer-settings', ViewerSettingsController)
application.register('comparison', ComparisonController)
application.register('dropdown', DropdownController)
application.register('timeago', TimeagoController)
application.register('resizable-table', ResizableTableController)
application.register('sortable', SortableController)
application.register('form', FormController)
application.register('modal', ModalController)
