[![Build status](https://circleci.com/gh/what-we-ate/what-we-ate.svg?style=shield)](https://circleci.com/gh/what-we-ate/what-we-ate)

# WhatWeAte

[![WhatWeAte at 31 May 2015](https://cloud.githubusercontent.com/assets/885223/7902825/cf1557f8-07be-11e5-93f0-facdfb4ffe82.png)](http://whatweate.co)

## Getting started

- Ruby 2.2.2
- Rails 4.2.1
- PostgreSQL
- Start server with `foreman start --port 3000`

## Staging and Production environments

Hosted on Heroku, [install the CLI](https://toolbelt.heroku.com/). [CircleCI](https://circleci.com/gh/what-we-ate/what-we-ate) automatically deploys `develop` to QA, `master` to Staging on green builds.

- **QA:** [whatweate-qa.herokuapp.com](http://whatweate-qa.herokuapp.com)
- **Staging:** [whatweate-staging.herokuapp.com](http://whatweate-staging.herokuapp.com)
- **Production:** [whatweate.co](http://whatweate.co) / [whatweate.herokuapp.com](http://whatweate.herokuapp.com)

### Deployment

```
heroku git:remote -a whatweate-qa -r qa
heroku git:remote -a whatweate-staging -r staging
heroku git:remote -a whatweate -r production

git push qa <branch>:master && heroku run rake db:migrate --app whatweate-staging
```
