// Responsible for toggle the sidebar

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  toggle(){
    $('#main-menu').sidebar('toggle')
  }
}
