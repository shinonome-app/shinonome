import * as ActiveStorage from "@rails/activestorage"
//import "@hotwired/turbo-rails"
import * as Turbo from '@hotwired/turbo'

import "~/main.css";

//export * as SnmComponent from "../src/main"

ActiveStorage.start()
Turbo.start()

console.log('Vite ⚡️ Rails')
console.log('Visit the guide for more information: ', 'https://vite-ruby.netlify.app/guide/rails')
