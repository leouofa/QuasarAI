// Responsible for sidebar settings and hiding

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect(){
    const sidebar = $(this.element)

    sidebar.sidebar('setting', 'dimPage', false)
    sidebar.sidebar('setting', 'transition', 'overlay')
    sidebar.sidebar('setting', 'mobileTransition', 'overlay')
  }

  hide(event){
    const sidebar = $(this.element)
    sidebar.sidebar('hide')
  }
}
