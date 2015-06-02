Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
Rails.application.config.assets.precompile += %w( admin.css admin.js html5shiv.min.js *.svg *.eot *.woff *.ttf )
