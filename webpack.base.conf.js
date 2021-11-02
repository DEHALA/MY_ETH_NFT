var webpack = require('webpack')
module.exports = {
    plugins: [
        new webpack.optimize.CommonsChunkPlugin({
          names: ['vendor', 'manifest']
        }),
        // new HtmlWebpackPlugin({
        //   template: 'public/index.html'
        // }),
        new webpack.ProvidePlugin({
          $: "jquery",
          jQuery: "jquery",
          "window.jQuery": "jquery"
        })
      ],
};