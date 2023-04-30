module.exports = {
    corePlugins: {
        preflight: false,
    },
    content: [
        './app/helpers/**/*.rb',
        './app/frontend/**/*.js',
        './app/views/**/*',
        './app/components/**/*',
    ],
    theme: {
        extend: {},
    },
    plugins: [],
}