[![Build status](https://circleci.com/gh/what-we-ate/what-we-ate.svg?style=shield)](https://circleci.com/gh/what-we-ate/what-we-ate)

# WhatWeAte

[![WhatWeAte at 31 May 2015](https://cloud.githubusercontent.com/assets/885223/7902825/cf1557f8-07be-11e5-93f0-facdfb4ffe82.png)](http://whatweate.co)

## Getting started

- Ruby 2.2.2
- Rails 4.2.1
- PostgreSQL
- Start server with `foreman start --port 3000`

## Staging and Production environments

Hosted on Heroku, [install the CLI](https://toolbelt.heroku.com/).

- **Staging:** [whatweate-staging.herokuapp.com](http://whatweate-staging.herokuapp.com)
- **Production:** [whatweate.co](http://whatweate.co) / [wwa1.herokuapp.com](http://wwa1.herokuapp.com)

### Deployment

```
heroku git:remote -a whatweate-staging -r staging
git push staging <branch>:master
heroku run rake db:migrate --app whatweate-staging
```

