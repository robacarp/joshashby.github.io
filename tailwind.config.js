const colors = require('tailwindcss/colors')

module.exports = {
  mode: "jit",
  purge: ["./_site/**/*.html"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        orange: colors.orange,
        yellow: colors.yellow,
        blue: colors.sky,
      }
    }
  },
  variants: {
    extend: {},
  },
  plugins: [require("@tailwindcss/typography")],
}
