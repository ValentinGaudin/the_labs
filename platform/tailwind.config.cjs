/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,js,jsx}"],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        primary : {
          DEFAULT : '#05EBAE'
        }
      }
    },
  },
  plugins: [],
}
