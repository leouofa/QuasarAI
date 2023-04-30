import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["button"]

  connect() {
  }

  submit(e) {
    this.buttonTarget.classList.add('loading')
    this.buttonTarget.disabled = true
  }
}