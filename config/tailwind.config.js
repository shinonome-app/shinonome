module.exports = {
  content: [
    './app/assets/stylesheets/*.css',
    './app/views/**/*.html.erb',
    './app/components/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js'
  ],
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
