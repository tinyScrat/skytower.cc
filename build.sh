#!/bin/sh

# build web apps
elm make webui/Main.elm --optimize --output=www/main.js
elm make webui/Login.elm --optimize --output=www/login.js
elm make webui/App.elm --optimize --output=www/app.js
elm make webui/BookStore.elm --output=www/book-store.js
elm make webui/EmbeddedApp.elm --optimize --output=www/embedded-app.js

# compress and mangle all js file into one
uglifyjs www/main.js www/login.js -c -m -o www/all.min.js
