// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "channels"

document.addEventListener("turbo:before-fetch-request", () => {
  // Always clear active focus just before Turbo sends request
  document.activeElement?.blur()
})