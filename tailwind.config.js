const colors = require('tailwindcss/colors')

const purge = [
  "./_site/**/*.html",
]

if (process.env.JEKYLL_ENV === "production")
  purge.push("../build/**/*.html")

module.exports = {
  mode: "jit",
  purge,
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
