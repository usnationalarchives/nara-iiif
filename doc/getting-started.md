This guide will help you prepare your OS X workstation for Ruby/Rails development.

### Installing Homebrew

[Homebrew](http://brew.sh) is a third-party package manager for OS X. It’s very similar to other tools you may have used, like Yum, Apt, or Portage. It installs many command line tools and libraries built for OS X.

These instructions assume you’re on the latest version of Mac OS X.

Homebrew installs all of its files in `/usr/local`. Apple promises that this directory is available for developer use, and it will not be affected by system updates. Even though Apple promises this, when you update to a new major version of OS X, you should probably re-install Homebrew and all of your packages anyway.

If do not yet have the Apple Command Line tools installed, you should run the following command. Dialog boxes will spring open to help you install the tools.

```shell
xcode-select --install
```

Now install Homebrew. Read everything printed to your screen carefully:

```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Run this command to check your computer for any issues. This command is great if you ever have any Homebrew issues in the future:

```shell
brew doctor
```

If everything looks good, you’re going to install everything that we need to develop with Ruby. This step will take a while.

```shell
brew update
brew install openssl
brew link openssl --force
brew install wget git imagemagick jpeg pngcrush awscli
brew install chruby ruby-install readline gdbm libyaml
brew upgrade --all
brew prune
brew cleanup -s
```

### Set your $PATH

You're going to install software in a few non-standard places. You’ll need to edit your shell profile to update your $PATH (the variable that sets where commands exist) and turn on chruby (if using it to manage Ruby versions).

**If you know how to work with a shell profiles, skip the next set of commands** and open your preferred profile (`~/.profile`, `~/.bashrc`, `~/.zshrc` etc)

If you didn’t install a new shell on OS X, the commands below will create a standard profile:

```shell
rm ~/.bashrc
rm ~/.bash_profile
touch ~/.profile
open ~/.profile
```

Add the following lines to the end of your shell profile and save it:

```shell
# Set a custom $PATH for working with Homebrew, Heroku, and Postgres

export USR_PATH="/usr/local/bin:/usr/local/sbin"
export HEROKU_PATH="/usr/local/heroku/bin"
export PG_PATH="/Applications/Postgres.app/Contents/Versions/latest/bin"
export OSX_PATH="/usr/bin:/usr/sbin:/bin:/sbin"

export PATH="$USR_PATH:$HEROKU_PATH:$PG_PATH:$OSX_PATH:$PATH"

# Activate chruby and the .ruby-version auto-switcher (only if using chruby)

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

# Define a function to install a version of MRI with ruby-install

function chruby-install {
  ruby-install --src-dir /tmp --cleanup --no-install-deps ruby $1 && \
  source ~/.profile && \
  chruby $1 && \
  gem update --system && \
  gem install --no-ri --no-rdoc rails rake bundler rack sass foreman
}
```

Now restart your terminal.

### Installing a Version of Ruby

In the previous steps we installed [chruby](https://github.com/postmodern/chruby), which is Threespot’s preferred Ruby version manager. It allows you to have multiple versions of Ruby cleanly installed on your computer. Alternatively, you could use [asdf](https://github.com/asdf-vm/asdf) and its [Ruby plugin](https://github.com/asdf-vm/asdf-ruby), which is what we use to manage Node.js versions.

To install a new Ruby version with chruby, use the function you just added to your bash profile. You may as well start by installing the two stable version of Ruby for now.

```
# These commands will take a while, but you can run them simultaneously in separately terminals windows.
Ruby 2.4.0
Ruby 2.3.3
Ruby 2.2.6
```

If using asdf, you can install them using these commands:
```bash
asdf install ruby 2.4.0
asdf install ruby 2.3.3
asdf install ruby 2.2.6
```

When you `cd` on your terminal, chruby looks for files named `.ruby-version` in the folder you switched to, or a file named `.ruby-version` in your home directory. If it finds those files, it automatically switch to the version of Ruby specified. All of Threespot’s projects have a `.ruby-version` file.

If using asdf, it will look for a file called `.tool-versions`, which is also present in all projects.

You should set your own personal version of Ruby as well. This version will be used if a project folder doesn’t specifiy one:

```shell
echo "2.3.1" > ~/.ruby-version
```

### Installing Postgres

You should download, install, and launch [Postgres.app](http://postgresapp.com), our preferred way to run a Postgres server on OS X. Postgres.app is great because the toolbar icon will monitor your Postgres server, and closing the app stops Postgres.

Note, after launching the app for the first time, you will need to create a new server and start it.

### Installing the Heroku Toolbelt

Download and install the [Heroku Toolbelt](https://toolbelt.heroku.com).

If you don’t already have a Heroku account, create a personal account at
[signup.heroku.com/login](https://signup.heroku.com/login)

Restart your terminal, then run:

```
heroku login
heroku update
heroku plugins:install heroku-certs
heroku plugins:install https://github.com/heroku/heroku-repo.git
```

You’re alll set! **Next, learn how to [set up a new Heroku project](https://github.com/Threespot/shortline/blob/master/doc/new-projects.md).**


### Installing a Version of Node

Threespot's preferred Node version manager is [`asdf`](https://github.com/asdf-vm/asdf). You'll need to install it first along with the [`nodejs`](https://github.com/asdf-vm/asdf-nodejs) plugin. To install the required Node version, you'll need to run the following command.

```bash
asdf install node 8.0.0
```

### Installing Yarn

We use [Yarn](https://yarnpkg.com) to install npm dependencies listed in `package.json`. We recommend installing it using homebrew:
```bash
brew install yarn
```
