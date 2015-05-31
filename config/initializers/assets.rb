Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
Rails.application.config.assets.precompile += %w( *.js *.css *.svg *.eot *.woff *.tff )
