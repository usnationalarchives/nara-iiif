### The Shortline Test Suite

In order to use the Shortline test suite you will need to create another environment config file for the test environment called `.env.test`. It should closely mirror the `.env` file for your development environment but you will need to provide unique values for for `SECRET_KEY_BASE` as well as set the environment names for Rails and Rack to `test`. If tests are added for file uploads you will need to create a unique Amazon S3 bucket for your test environment and include it's name on the `S3_BUCKET_NAME` line in this file.

```makefile
RAILS_ENV=test
RACK_ENV=test
DATABASE_URL=postgres://localhost/shortline-test
WEB_CONCURRENCY=1
BUGSNAG_API_KEY=
EXPECTED_HOSTNAME=
PORT=8080
SECRET_KEY_BASE=
S3_BUCKET_NAME=xxx
AWS_ACCESS_KEY_ID=xxx
AWS_SECRET_ACCESS_KEY=xxx
SMTP_LOGIN=
SMTP_PASSWORD=
SMTP_PORT=
SMTP_SERVER=
```

You will need to create a test environment database and load the database schema into it.
You must also add the `DATABASE_URL` settings to your `.env.test` file. **Do not reuse your development database because it will be wiped out every time you run tests.**

```shell
createdb shortline-test
RAILS_ENV=test rake db:schema:load
```

Once the test environment is properly configured you can run the tests with:

```shell
rake test
```
