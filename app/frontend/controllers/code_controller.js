import { Controller } from '@hotwired/stimulus'
import CodeMirror from 'codemirror'
import 'codemirror/mode/yaml/yaml'

export default class extends Controller {
  connect() {
    this.editor = new CodeMirror.fromTextArea(this.element, {
      lineNumbers: true,
      lineWrapping: true,
      extraKeys: {
        'Shift-Tab': 'indentLess',
        'Tab': 'indentMore',
      },
      mode: 'yaml'
    })

    this.editor.on('blur', () => {
      this.editor.save()
    })

    this.editor.setSize(null, 800)
  }
}
