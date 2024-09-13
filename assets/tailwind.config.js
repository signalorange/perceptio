// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
const colors = require("tailwindcss/colors"); // <-- ADD THIS LINE
const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
    content: [
      "../lib/*_web.ex",
      "../lib/*_web/**/*.*ex",
      "./js/**/*.js",
      "../deps/petal_components/**/*.*ex", // <-- ADD THIS LINE
    ],
    darkMode: "class",
    theme: {
      extend: {
  
        // ADD THESE COLORS (can pick different ones from here: https://tailwindcss.com/docs/customizing-colors)
        colors: {
          primary: colors.blue,
          secondary: colors.pink,
          success: colors.green,
          danger: colors.red,
          warning: colors.yellow,
          info: colors.sky,
  
          // Options: slate, gray, zinc, neutral, stone
          gray: colors.gray,
        },
      },
    },
  
    plugins: [
      require("@tailwindcss/forms"),
      plugin(({ addVariant }) =>
        addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])
      ),
      plugin(({ addVariant }) =>
        addVariant("phx-click-loading", [
          ".phx-click-loading&",
          ".phx-click-loading &",
        ])
      ),
      plugin(({ addVariant }) =>
        addVariant("phx-submit-loading", [
          ".phx-submit-loading&",
          ".phx-submit-loading &",
        ])
      ),
      plugin(({ addVariant }) =>
        addVariant("phx-change-loading", [
          ".phx-change-loading&",
          ".phx-change-loading &",
        ])
      ),
    ],
  };
