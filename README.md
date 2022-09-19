[![Gem Version](https://badge.fury.io/rb/credman.svg)](https://badge.fury.io/rb/credman)

# Credman

Handy console tool for developers to manage Rails credentials.

## Motivation

Rails credentials is a nice tool to store encrypted credentials directly in your repo. Starting with Rails 6.0 it brings multi environment credentials feature that allows us to split credentials into separate files.

But it also brought a lot of pain for developers:
- Each enviroment credentials file must have a complete list of all keys. It's easy to forget to add a key into one of the environments (see [set](#credman-set) and [delete](#credman-delete) command)
- You have to manually open each environment file. It's ok for one file but not for 3 or more. It also brings mistakes you might miss until deploy to production. (see [set](#credman-set) and [delete](#credman-delete) command)
- Merge conflicts become a hell since files are encrypted (see [conflicts](#credman-conflicts) command)
- You can't easily see what keys were added/changed/deleted in the current branch (see [diff](#credman-diff) command)

This gem is designed to solve all these problems and make life easier for developers who use multi environment credentials.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'credman'
end
```

## Usage

List of all commands:

### credman help
```
bundle exec credman
or
bundle exec credman help
or
bundle exec credman usage
```

<details>
  <summary>Output</summary>

```
Commands:
  credman conflicts                # Help to resolve merge conflicts for credentials
  credman delete KEYS              # Delete keys for given environments
  credman diff [BRANCH]            # Show credentials diff between given branch (heroku by default) and current changes
  credman get KEYS                 # Find keys in credentials files for each environment
  credman list                     # List of all keys for each environment
  credman set KEY VALUE            # Set a value to the key provided for given environments
```

</details>

Details of any command:

```
bundle exec credman set -h
```

<details>
  <summary>Output</summary>

```
Command:
  credman set

Usage:
  credman set KEY VALUE

Description:
  Set a value to the key provided for given environments

Arguments:
  KEY                               # REQUIRED
  VALUE                             # REQUIRED

Options:
  --environments=VALUE1,VALUE2,.., -e VALUE  # filter for environments, default: []
  --help, -h
```

</details>

### credman list
List all your keys for all environments.

```
bundle exec credman list
```

<details>
  <summary>Output</summary>

```
development:
	aws.api_key:	123
	...
test:
	aws.api_key:	nil
	...
production:
	aws.api_key:	nil
	...
```
</details>

### credman get
Getting a particular key's values.

```
bundle exec credman get google.recaptcha.secret circle_ci.token
```

<details>
  <summary>Output</summary>

```
development:
	google.recaptcha.secret:	nil
	circle_ci.token:	<secret>
test:
	google.recaptcha.secret:	nil
	circle_ci.token:	nil
production:
	google.recaptcha.secret:	<secret>
	circle_ci.token:	<secret>
```
</details>

### credman set

Add/change a value for a particular key. `-e` attribute is mandatory for this command.


```
bundle exec credman set new_service.super_key new_secret_value -e development,test,production
```

<details>
  <summary>Output</summary>

```
development:
	new_service.super_key:	ADDED: new_secret_value
test:
	new_service.super_key:	ADDED: new_secret_value
production:
	new_service.super_key:	ADDED: new_secret_value
```
</details>

### credman delete

Delete for keys. `-e` attribute is mandatory for this command.

```
bundle exec credman delete new_service.super_key new_service.another_key -e development,test,production
```

<details>
  <summary>Output</summary>

```
development:
	new_service.super_key:	✅ deleted
	new_service.another_key:	❌ key not found, can't delete
test:
	new_service.super_key:	✅ deleted
	new_service.another_key:	❌ key not found, can't delete
production:
	new_service.super_key:	✅ deleted
	new_service.another_key:	❌ key not found, can't delete
```
</details>

### credman diff

Shows all keys changed compared with `main` branch by default.
You can set the default branch by adding `config/credman.yml` file with `default_diff_branch: your_branch`
You can specify any branch from origin you want to. For example `credman diff my_branch`

```
bundle exec credman diff
```

<details>
  <summary>Output</summary>

```
development:
	new_service.super_key:	 ADDED: "new_secret_value"
test:
	new_service.super_key:	 ADDED: "new_secret_value"
production:
	new_service.super_key:	 ADDED: "new_secret_value"
```
</details>

### credman conflicts

Run it if you have merge conflicts in `configs/credentials/*.yml.enc`.
That interactive tool will help you resolve the conflict.
In most of cases it will just automagically resolve the conflicts.
In case of a key was changed in both branches it will ask you to choose the correct value.

```
bundle exec credman conflicts
```

<details>
  <summary>Output</summary>

```
development:
        ❗️ The key another_key changed in both branches, their: "another_value", our: "conflicting_value"
Which one should we use? Please type `their` or `our` to apply particular change or enter to abort.
> their
✅ another_key set as "another_value"
✅ Merged config for rspec has been saved
          resolves conflict with user input
```
</details>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Uscreen-video/credman.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
