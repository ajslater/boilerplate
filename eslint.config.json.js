import eslintJson from "@eslint/json";

import { IGNORES } from "./eslint.config.js";

export default [
  {
    ignores: IGNORES,
  },
  {
    files: ["*.json", "**/*.json"],
    ...eslintJson.configs.recommended,
    language: "json/json",
  },
  {
    files: ["frontend/src/choices/browser-map.json"],
    rules: {
      "json/no-empty-keys": "off",
    },
  },
];
