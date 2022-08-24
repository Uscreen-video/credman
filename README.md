# Credman

Handy console command for developers to manage Rails credentials.

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

Details of any command:

```
bundle exec credman set -h
```

### credman list
List all your keys for all environments.

```
bundle exec credman list
```

### credman get
Getting a particular key's values.

```
bundle exec credman get google.maps.api_key github.private_key
```

### credman set

Add/change a value for a particular key. `-e` attribute is mandatory for this command.


```
bundle exec credman set new_service.super_key new_secret_value -e development,test,staging,production
```

### credman delete

Delete for keys. `-e` attribute is mandatory for this command.

```
bundle exec credman delete new_service.super_key new_service.another_key -e development,test,staging,production
```

### credman diff

Shows all keys changed compared with `heroku` branch by default. You can specify any branch from origin you want to. For example `bin/earl diff my_branch`

```
> bundle exec credman diff
development:
	new_service.super_key:	 ADDED: "new_secret_value"
test:
	new_service.super_key:	 ADDED: "new_secret_value"
staging:
	new_service.super_key:	 ADDED: "new_secret_value"
production:
	new_service.super_key:	 ADDED: "new_secret_value"
```

### credman conflicts
Run it if you have merge conflicts in `configs/credentials/*.yml.enc`. That interactive tool will help you resolve the conflict.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Uscreen-video/credman.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
