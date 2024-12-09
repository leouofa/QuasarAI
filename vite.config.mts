import { defineConfig } from 'vite'
import inject from "@rollup/plugin-inject";
import ViteRails from 'vite-plugin-rails'

export default defineConfig({
  css: {
    preprocessorOptions: {
      scss: {
        verbose: true,
        silenceDeprecations: ['legacy-js-api', 'color-functions', 'global-builtin', 'import', 'mixed-decls'],
      },
    },
  },
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
