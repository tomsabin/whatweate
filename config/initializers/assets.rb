Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts', 'materialize', 'material-design-icons')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts', 'materialize', 'roboto')
Rails.application.config.assets.precompile += %w( style_guide.css admin.css admin.js html5shiv.min.js *.svg *.eot *.woff *.woff2 *.ttf )
