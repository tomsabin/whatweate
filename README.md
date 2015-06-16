[![Build status](https://circleci-badges.herokuapp.com/whatweate/whatweate/:circle-ci-badge-token)](https://circleci.com/gh/whatweate/whatweate)
[![Test Coverage](https://codeclimate.com/github/whatweate/whatweate/badges/coverage.svg)](https://codeclimate.com/github/whatweate/whatweate/coverage)
[![Code Climate](https://codeclimate.com/github/whatweate/whatweate/badges/gpa.svg)](https://codeclimate.com/github/whatweate/whatweate)

# WhatWeAte

[![WhatWeAte at 31 May 2015](https://cloud.githubusercontent.com/assets/885223/7902825/cf1557f8-07be-11e5-93f0-facdfb4ffe82.png)](http://whatweate.co)

## Getting started

- Ruby 2.2.2
- Rails 4.2.1
- PostgreSQL
- Start server with `foreman start --port 3000`

## Dependencies

- [Redis](http://redis.io/) for [Sidekiq](sidekiq.org)
- Photo uploading and processing is handled by [CarrierWave](https://github.com/carrierwaveuploader/carrierwave), you'll need to install `imagemagick` for versions (e.g. thumbnail). This should be as easy as `brew install imagemagick`.

## Staging and Production environments

Hosted on Heroku, [install the CLI](https://toolbelt.heroku.com/). [CircleCI](https://circleci.com/gh/what-we-ate/what-we-ate) automatically deploys `develop` to QA, `master` to Staging on green builds.

- **QA:** [whatweate-qa.herokuapp.com](http://whatweate-qa.herokuapp.com)
- **Staging:** [whatweate-staging.herokuapp.com](http://whatweate-staging.herokuapp.com)
- **Production:** [whatweate.co](http://whatweate.co) / [whatweate.herokuapp.com](http://whatweate.herokuapp.com)

### Deployment

```
heroku git:remote -a whatweate-qa -r qa
heroku git:remote -a whatweate-staging -r staging
heroku git:remote -a whatweate-production -r production
```

QA and Staging are [configured](https://github.com/whatweate/whatweate/blob/develop/circle.yml) to be continuously deployed from develop and master respectively. Production deploys are manual using the following.

```
git push production <branch>:master && heroku run rake db:migrate -r production
```

