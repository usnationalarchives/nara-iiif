# NARA IIIF Presentation Application

This project uses Rails to support the components neccessary for displaying a IIIF compliant viewer. It includes configuration for gems we like, such as [Puma][], [Dalli][], [Amazon S3][], [Seed-fu][], and [Paperclip][], and it's ready to deploy to Heroku.

[Puma]: http://puma.io
[Dalli]: https://github.com/mperham/dalli
[Amazon S3]: http://aws.amazon.com/s3/
[Seed-fu]: https://github.com/mbleigh/seed-fu
[Paperclip]: https://github.com/thoughtbot/paperclip

### Environment Links
[Prototype](http://nara-iiif.herokuapp.com/items)  
[Viewer Example](http://nara-iiif.herokuapp.com/items/1/viewer)

### Getting Started With Ruby

If you do not have a Ruby development environment, please review the guides below:

- [Installing Homebrew](doc/getting-started.md#installing-homebrew)
- [Setting Your $PATH](doc/getting-started.md#set-your-path)
- [Installing a Version of Ruby](doc/getting-started.md#installing-a-version-of-ruby)
- [Installing Postgres](doc/getting-started.md#installing-postgres)
- [Installing the Heroku Toolbelt](doc/getting-started.md#installing-the-heroku-toolbelt)
- [Starting a New Heroku + Shortline Project](doc/new-projects.md#starting-a-new-heroku--rails-project)
- [Provisioning Amazon S3](doc/new-projects.md#provision-amazon-s3)
- [Rails Security Policy](doc/security.md)

### Getting Started with Node

If you do not have a Node development environment, please review the guides below:

- [Installing a Version of Node](doc/getting-started.md#installing-a-version-of-node)
- [Installing Yarn](doc/getting-started.md#installing-yarn)

### Working on this Project

Clone this project and change to it. Then attach to the Heroku application.

```shell
git clone -o github git@github.com:Threespot/nara-iiif.git
cd nara-iiif
heroku git --ssh-git --app nara-iiif
```

Pull down a copy of the production database to work on locally:

```shell
dropdb nara-iiif
heroku pg:pull DATABASE nara-iiif
```

Now install the dependencies:

```shell
bundle install #ruby
yarn install   #node
```

### Configure the Environment

This codebase does not contain any credentials. Instead, developers and Heroku [store configuration in the environment](http://12factor.net/config). On Heroku, their platform handles environment variables you set via `heroku config`. Locally, you store credentials in a special `.env` file in the project folder.

✋ **IMPORTANT:** Always store configuration in the environment. Never commit code that contains credentials. If you commit code with credentials in it, those credentials are no longer safe to use and must be replaced.

Make your environment file:

```
touch .env
open .env
```

Copy the contents of the [`env.example`](/env.example) file

The file is in key-value format, with one key per line. When you boot the Rails server, it will look for this file and set the specified environment variables. Each variable is described below.

<details>
  <summary>Variable Details</summary>

##### RAILS_ENV and RACK_ENV

These variables cause the Rails app to boot differently depending on the working context.

- They should both be set to `development` in development mode
- They should both be set to `production` on Heroku.

##### DATABASE_URL

This is a Postgres URI to your database. It should be in the form `postgres://localhost/<DATABASE_NAME>`.

If you are not using Postgres.app, you might need to provide a user and password, so the URI will be in the form `postgres://<USERNAME>:<PASSWORD>@<HOST>:<PORT>/<DATABASE_NAME>`.

Heroku sets this value in production for you. Do not change Heroku’s value.

##### WEB_CONCURRENCY

The number of Rails servers to create per Heroku dyno.

- In development this should be `1`. (Just one server for you)
- On Heroku it’s `2` or `3`, depending on how much memory you have available.

##### EXPECTED_HOSTNAME

This should be set to the scheme and domain name that the server will run on.

In development, if you expect to access the application via your network address or IP address, it needs to be set accordingly:

- If you want to use something like `http://dev.threespot.com:8080`, set this value to `http://dev.threespot.com`
- If you want to use something like `http://0.0.0.0:8080`, set this value to `http://0.0.0.0`

In production, this should be the official URL of the server, ex. `https://www.threespot.com`. Visits to the production URL that are not on this address will be forcibly redirected to it.

This setting does not include the port, see below.

##### PORT

The port for the application to listen on.

- In development, you should pick your favorite userspace port to develop on, like `8080` or `5000`.
- In production, this is set for you by Heroku. Do not change Heroku’s value.

##### SECRET_KEY_BASE

This variable sets the key that Rails uses to sign cookie and sessions. Changing this key after it's set will rotate every cookie and session on the site. It should be a random string of at least 64 characters, or the application may be vulnerable to session hijacking. Generate a good value with `openssl rand -hex 32`

- Heroku sets this for you in production.
- Your development and Heroku key should be **different**.

##### S3_BUCKET_NAME, AWS_ACCESS_KEY_ID, and AWS_SECRET_ACCESS_KEY

Set `S3_BUCKET_NAME` equal to your Amazon S3 bucket name. (Remember that the bucket name is different for Heroku and each developer.)

Set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` to your AWS key pair.

  </details>

### Booting the App

If your dependencies are installed and the environment is A-OK, you should be able to start the Rails server and Webpack dev server with:

```shell
bin/server
```