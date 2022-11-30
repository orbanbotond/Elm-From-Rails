import {
  Elm
} from '../elm/Navigation.elm'

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { lineItems: Array }

  connect() {
    let node = this.element;    
    Elm.Main.init( {node: node});
  }
}
