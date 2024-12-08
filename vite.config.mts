import { defineConfig } from 'vite'
import ViteRails from 'vite-plugin-rails'
import inject from "@rollup/plugin-inject";

export default defineConfig({
  plugins: [
    inject({   // => that should be first under plugins array
      $: 'jquery',
      jQuery: 'jquery',
    }),
    ViteRails({
      fullReload: {
        additionalPaths: ['app/components/**/*']
      }
    }),
  ],
  build: { sourcemap: false },
})
