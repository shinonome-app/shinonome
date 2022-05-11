// Entry point for the build script in your package.json

import * as ActiveStorage from "@rails/activestorage"
// import "channels"
import "@hotwired/turbo-rails"

ActiveStorage.start()
