import { Application } from "@hotwired/stimulus"
import { registerControllers } from 'stimulus-vite-helpers'

// Stimulus Plugins
import CharacterCounter from 'stimulus-character-counter'

// Start the Stimulus application.
const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Controller files must be named *_controller.js.
const controllers  = import.meta.globEager('./**/*_controller.js')
registerControllers(application, controllers)

// Stimulus Plugins
application.register('character-counter', CharacterCounter)