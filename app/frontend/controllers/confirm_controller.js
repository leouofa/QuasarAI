import {Controller} from '@hotwired/stimulus'

export default class extends Controller {
    static values = {
        message: String,
        destination: String
    }

    navigate(e) {
        e.preventDefault()
        const destintion = this.destinationValue

        $('body').modal('confirm', this.messageValue, function (value) {
            if (value === true) window.location.replace(destintion)
        })
    }

    delete(e) {
        e.preventDefault()

        $('body').modal('confirm', this.messageValue, function (confirmed) {
            if (confirmed === true) {
                e.target.form.submit()
            }
        })
    }

}