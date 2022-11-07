import {
  Elm
} from '../elm/Form.elm'

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { lineItems: Array}

  connect() {
    let node = this.element;    
    Elm.Main.init( {node: node});
  }
}
