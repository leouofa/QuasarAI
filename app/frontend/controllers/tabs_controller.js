import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    $('.item', this.element).tab({
      history: true,
      historyType: 'hash'
    });
  }
}