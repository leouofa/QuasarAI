module.exports = {
  inputDir: './app/frontend/icons/processing', // (required)
  outputDir: './app/frontend/icons/compiled', // (required)
  fontTypes: ['woff', 'woff2'],
  assetTypes: ['css'],
  normalize: true,
  name: 'icon',
  templates: {
    css: './app/frontend/icons/templates/css.hbs'
  },
  getIconId: ({
    basename, // `string` - Example: 'foo';
    relativeDirPath, // `string` - Example: 'sub/dir/foo.svg'
    absoluteFilePath, // `string` - Example: '/var/icons/sub/dir/foo.svg'
    relativeFilePath, // `string` - Example: 'foo.svg'
    index // `number` - Example: `0`
  }) => [index, basename].join('-') // '0_foo'
};
