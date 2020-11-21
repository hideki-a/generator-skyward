module.exports = ctx => ({
  map: ctx.options.map,
  parser: ctx.options.parser,
  plugins: {
    "postcss-sort-media-queries": { sort: "mobile-first" },
    autoprefixer: { grid: true },
  }
});
