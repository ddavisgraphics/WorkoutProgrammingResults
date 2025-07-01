// tailwind.config.js
module.exports = {
  content: [
    './app/views/**/*.{erb,html}',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        primary: '#4F46E5', // Indigo-600
        'primary-dark': '#4338CA', // Indigo-700
        secondary: '#10B981', // Emerald-500
        'secondary-dark': '#059669', // Emerald-600
        danger: '#EF4444', // Red-500
        'danger-dark': '#DC2626', // Red-600
        neutral: '#6B7280', // Gray-500
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms')
  ],
}
