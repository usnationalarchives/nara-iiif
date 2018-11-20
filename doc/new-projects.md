### Starting a New Heroku + Shortline Project

First, set up a [new GitHub project](https://github.com/new).

Then, [download Shortline as an archive](https://github.com/Threespot/shortline/archive/master.zip). Rename the folder, change to it, and set up Git.

```shell
cd your-project-name
git init
git remote add github git@github.com:threespot/your-project-name.git
```

Now create a new Heroku application:

```shell
heroku apps:create your-project-name
heroku git:remote --ssh-git --app your-project-name
```

Add buildpack settings, so that you have nodejs for npm install and jpegtran for image processing:

```
heroku buildpacks:add --index 1 https://github.com/aeby/heroku-buildpack-jpegtran
heroku buildpacks:add --index 2 heroku/ruby
```

If you're not sure what add-ons to provision for a new Rails project start with these. All of them are free:

```shell
heroku addons:create heroku-postgresql:hobby-dev
heroku addons:create mailgun:starter
heroku addons:create memcachier:dev
heroku pg:backups schedule --at '03:00 America/New_York' DATABASE_URL
```

Now you’ve got two Git remotes, `github` and `heroku`. Always push your changes daily to GitHub. To deploy new site code, push to the `master` branch on Heroku.

```shell
# Pushing to GitHub
git push github master

# Make a code deployment to Heroku
git push heroku master

# Run this command to look at your Heroku app
heroku open
```

### File and Security Check

✋ **IMPORTANT:** You need to check the following files to ensure that they meet project requirements:

```text
config/application.rb
config/enviroments/production.rb
public/robots.txt
config/initializers/secure_headers.rb
```

### Provision Amazon S3

Outside of Heroku, we need to store files on Amazon S3. You’ll likely need to create multiple Amazon buckets.

You'll need to obtain an AWS key pair from the client for their Amazon account. [Here is an email template that you can use](https://gist.github.com/csuhta/9a7d49dd0916080a2047#amazon-s3).

The key pair you obtain must have permission `AmazonS3FullAccess`, and it must **not** be the master key pair for the account, that pair is too dangerous to use.

Once you have the key pair, you can create buckets on their account using an app like [Transmit](https://panic.com/transmit/) or the AWS command line tools.

Buckets should be named similar to this format:

```text
your-project-name
your-project-name-review
your-project-name-staging
your-project-name-dev-colgrove
your-project-name-dev-barbot
```

### S3 Bucket CORS policy

If you intend to use the S3 upload (`s3_uploader`) form helper, you'll need to set the approipate CORS configuration for each bucket.
```shell 
# Configure AWS profile
aws configure --profile PROFILE_NAME
# Apply CORS settings
aws s3api put-bucket-cors --bucket=BUCKET_NAME --cors-configuration=file://~/path/to/project/config/s3/cors.json --profile PROFILE_NAME
```

### Further Reading

- Heroku wrote and follows the tenants of the [12 Factor application](http://12factor.net/config). You should read that entire site.
- Heroku has an article on [getting started with Rails](https://devcenter.heroku.com/articles/getting-started-with-rails4).
