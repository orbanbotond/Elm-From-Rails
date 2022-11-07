import {
  Elm
} from '../Main.elm'  // it's a relative path so make sure you set it accordingly. 
                      // remember this elm code is placed in: app/javascript/Main.elm 

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { lineItems: Array}

  connect() {
    let node = this.element;    
    Elm.Main.init( {node: node});
  }
}
