import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = []

  initialize() {
    // Called once, when the controller is first instantiated
  }

  connect() {
    const toast = $('#toast');
    if (toast.length > 0) {
      if (toast.data('type') === 'error') {
        $('body').toast({
          title: 'Error',
          class: 'red',
          message: toast.data('message'),
          position: 'bottom right',
          showProgress: 'bottom',
          displayTime: 30000
        });
      } else {
        $('body').toast({
          title: 'Notice',
          class: 'purple',
          message: toast.data('message'),
          position: 'bottom right',
          showProgress: 'bottom',
          displayTime: 8000
        });
      }
    }
  }

  disconnect() {
    // Called any time the controller is disconnected from the DOM
  }
}