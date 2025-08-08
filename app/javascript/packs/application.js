// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Import Bootstrap
import 'bootstrap/dist/js/bootstrap.bundle.min.js'

// Import jQuery
import $ from 'jquery'
window.$ = window.jQuery = $

// Import other dependencies
import 'jqtree/tree.jquery.js'
import 'typeahead.js/dist/typeahead.bundle.min.js'
import 'pickadate/lib/picker.js'
import 'pickadate/lib/picker.date.js'

// Import styles
import 'bootstrap/dist/css/bootstrap.min.css'
import 'pickadate/lib/themes/default.css'
import 'pickadate/lib/themes/default.date.css'