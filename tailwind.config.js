module.exports = {
  mode: 'jit',
  purge: ['./app/views/**/*.html.erb', './app/helpers/**/*.rb', './app/javascript/**/*.js'],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        // オレンジ
        primary: '#FFA45B',
        // イエロー
        secondary: '#FFDA77',
        // ホワイト
        tertiary: '#FBF6F0',
        // スカイブルー
        quaternary: '#AEE6E6',
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
