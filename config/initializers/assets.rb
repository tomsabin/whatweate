Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.precompile << %w( html5shiv.min.js )
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'fonts')
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)$/
