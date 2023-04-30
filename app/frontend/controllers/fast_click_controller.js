import { Controller } from '@hotwired/stimulus'

export default class extends Controller {

  click(e) {
    e.srcElement.classList.add('loading')
  }
}