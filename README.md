[![Gem Version](https://badge.fury.io/rb/credman.svg)](https://badge.fury.io/rb/credman)

# Credman

Handy console tool for developers to manage Rails credentials.

<a href="https://www.uscreen.tv/">
<svg width="136" height="29" viewBox="0 0 136 29" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect width="100%" height="100%" fill="white" />
<g clip-path="url(#clip0_6_0)">
<path d="M7.06838 22.476C7.20938 22.476 7.35338 22.466 7.49538 22.446L19.5464 20.742C19.6634 21.599 19.9034 22.415 20.2514 23.174L7.83638 24.929C7.57738 24.965 7.32138 24.983 7.06738 24.983C4.36038 24.983 1.99738 22.961 1.61338 20.166L0.0533843 8.835C-0.366616 5.778 1.73738 2.954 4.75338 2.528L22.2484 0.054C22.5074 0.018 22.7634 0 23.0174 0C25.7254 0 28.0874 2.022 28.4714 4.817L29.3174 10.964C28.9384 10.914 28.5544 10.879 28.1614 10.879C27.7054 10.879 27.2604 10.924 26.8234 10.992L26.0214 5.164C25.8144 3.65 24.5224 2.507 23.0174 2.507C22.8754 2.507 22.7324 2.517 22.5904 2.537L5.09538 5.011C4.29138 5.124 3.57838 5.549 3.08938 6.206C2.59938 6.862 2.39238 7.673 2.50338 8.488L4.06338 19.819C4.27138 21.334 5.56338 22.476 7.06838 22.476Z" fill="#1A202C"/>
<path d="M52.7404 17.478C54.4544 17.478 55.8504 16.035 55.8504 14.26V6.79102H58.3714V14.259C58.3714 17.466 55.8454 20.076 52.7394 20.076C49.6334 20.076 47.1074 17.466 47.1074 14.259V6.79102H49.6284V14.26C49.6284 16.035 51.0244 17.478 52.7404 17.478Z" fill="#1A202C"/>
<path d="M94.2393 6.79102H93.7443C92.9423 6.79102 92.2413 6.93102 91.6583 7.20802L91.6563 7.21302L91.6423 7.22002C91.0353 7.50502 90.5143 7.86702 90.0913 8.29402L89.6413 8.74902V6.79102H87.0703V20.076H89.6413V14.273C89.6413 12.945 90.0063 11.795 90.7273 10.855C91.4903 9.86901 92.4463 9.39102 93.6493 9.39102H94.2393V6.79102Z" fill="#1A202C"/>
<path d="M66.5944 12.263C67.2574 12.402 67.8934 12.608 68.4894 12.874C69.0974 13.15 69.6104 13.537 70.0144 14.021C70.4444 14.535 70.6624 15.235 70.6624 16.101C70.6624 17.426 70.1904 18.455 69.2594 19.159C68.4434 19.785 67.3044 20.077 65.6774 20.077C64.0834 20.077 62.7914 19.631 61.8354 18.751C61.0274 18.038 60.5404 17.045 60.4214 15.875H62.8944C63.0374 16.704 63.5174 17.243 64.4044 17.571C65.0834 17.803 65.8434 17.877 66.4944 17.777C66.8144 17.726 67.1164 17.641 67.3914 17.527C67.9854 17.27 68.2614 16.873 68.2614 16.272C68.2614 15.891 68.1294 15.61 67.8584 15.412C67.5174 15.162 67.0794 14.955 66.5574 14.797C66.0144 14.63 65.4244 14.479 64.7574 14.335C64.0654 14.184 63.4274 13.982 62.8634 13.733C62.2604 13.469 61.7504 13.097 61.3464 12.632C60.9114 12.131 60.6904 11.446 60.6904 10.596C60.6904 9.35499 61.1174 8.37999 61.9564 7.69499C62.7014 7.07899 63.8254 6.79199 65.4934 6.79199C66.9634 6.79199 68.1464 7.18399 69.0104 7.95999C69.7454 8.62999 70.1764 9.52799 70.2904 10.626L70.2934 10.652H67.8794L67.8764 10.631C67.8314 10.257 67.6934 9.11899 65.3664 9.11899C63.3274 9.11899 63.0914 9.86299 63.0914 10.424C63.0914 10.79 63.2124 11.037 63.4854 11.228C63.8174 11.456 64.2564 11.652 64.7904 11.81C65.3594 11.978 65.9664 12.131 66.5944 12.263Z" fill="#1A202C"/>
<path d="M77.5145 9.45297L77.5014 9.45697C77.0214 9.68497 76.6134 9.99497 76.2895 10.38C75.5685 11.197 75.2185 12.197 75.2185 13.434C75.2185 14.667 75.5665 15.668 76.2814 16.493C76.9734 17.294 77.9005 17.651 79.2895 17.651C79.9795 17.651 80.5684 17.455 81.0904 17.052C81.6184 16.661 82.0075 16.137 82.2495 15.494L82.3425 15.258H84.9995L84.8534 15.742C84.4725 17.029 83.7585 18.081 82.7325 18.87C81.6615 19.672 80.3745 20.079 78.9105 20.079C76.9875 20.079 75.5125 19.468 74.3985 18.211C73.2794 16.935 72.7104 15.328 72.7104 13.433C72.7104 11.541 73.2785 9.93797 74.3965 8.66697C75.5085 7.40697 76.9845 6.79297 78.9105 6.79297C80.3725 6.79297 81.6564 7.19797 82.7254 7.99697C83.7505 8.77797 84.4664 9.83097 84.8534 11.13L84.9995 11.613H82.3435L82.2524 11.377C82.0034 10.728 81.6134 10.203 81.0925 9.81397C80.5605 9.41397 79.9715 9.21997 79.2895 9.21997C78.6035 9.21997 77.9955 9.23697 77.5145 9.45297Z" fill="#1A202C"/>
<path d="M130.221 6.8291C127.034 6.8291 124.442 9.3011 124.442 12.3391V19.4131H127.03V12.3391C127.03 10.6571 128.462 9.2901 130.221 9.2901C131.982 9.2901 133.414 10.6571 133.414 12.3391V19.4131H136V12.3391C136 9.3011 133.408 6.8291 130.221 6.8291Z" fill="#1A202C"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M96.8733 8.75902C98.0343 7.45302 99.5513 6.79102 101.384 6.79102C103.218 6.79102 104.735 7.45102 105.889 8.75302C106.976 10.01 107.527 11.617 107.527 13.53V14.647H97.7933L97.8933 14.992C98.0883 15.672 98.4453 16.134 98.9223 16.617C99.6073 17.311 100.459 17.648 101.524 17.648C102.675 17.648 103.545 17.239 104.186 16.396L104.192 16.387H106.991L106.977 16.418C106.522 17.497 105.892 18.355 105.106 18.967C104.171 19.703 102.957 20.076 101.499 20.076C99.6533 20.076 98.1213 19.413 96.9493 18.107C95.7833 16.81 95.2393 15.355 95.2393 13.53C95.2393 11.623 95.7893 10.018 96.8733 8.75902ZM97.9403 11.821L97.8313 12.172H104.935L104.828 11.821C104.629 11.17 104.308 10.633 103.847 10.178C103.181 9.53202 102.376 9.21802 101.384 9.21802C100.39 9.21802 99.5843 9.53202 98.9193 10.178C98.4583 10.635 98.1373 11.172 97.9403 11.821Z" fill="#1A202C"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M115.721 6.79102C113.888 6.79102 112.371 7.45302 111.21 8.75902C110.126 10.017 109.576 11.622 109.576 13.53C109.576 15.355 110.12 16.81 111.287 18.107C112.459 19.413 113.991 20.076 115.837 20.076C117.295 20.076 118.508 19.703 119.443 18.967C120.228 18.356 120.858 17.499 121.316 16.418L121.329 16.387H118.53L118.523 16.397C117.882 17.239 117.012 17.648 115.862 17.648C114.796 17.648 113.945 17.311 113.26 16.617C112.782 16.134 112.425 15.672 112.23 14.992L112.131 14.647H121.865V13.53C121.865 11.617 121.314 10.01 120.227 8.75302C119.071 7.45102 117.554 6.79102 115.721 6.79102ZM112.169 12.172L112.276 11.821C112.475 11.171 112.796 10.634 113.256 10.178C113.921 9.53202 114.727 9.21802 115.721 9.21802C116.712 9.21802 117.517 9.53202 118.183 10.178C118.645 10.632 118.966 11.169 119.165 11.821L119.272 12.172H112.169Z" fill="#1A202C"/>
<path d="M29.3184 10.964C28.9394 10.914 28.5554 10.879 28.1624 10.879C27.7064 10.879 27.2614 10.925 26.8244 10.992C22.6534 11.636 19.4584 15.223 19.4584 19.565C19.4584 19.965 19.4944 20.356 19.5474 20.741C19.6644 21.598 19.9034 22.414 20.2524 23.173C21.6264 26.167 24.6474 28.251 28.1634 28.251C32.9714 28.251 36.8684 24.362 36.8684 19.565C36.8674 15.16 33.5784 11.53 29.3184 10.964ZM31.8304 19.857L26.3754 23.093C26.1464 23.23 25.8534 23.066 25.8534 22.802V16.33C25.8534 16.066 26.1464 15.902 26.3754 16.039L31.8304 19.275C32.0524 19.406 32.0524 19.725 31.8304 19.857Z" fill="#006AFF"/>
<path d="M26.3744 16.038C26.1454 15.902 25.8524 16.065 25.8524 16.329V22.801C25.8524 23.065 26.1454 23.229 26.3744 23.092L31.8294 19.856C32.0524 19.724 32.0524 19.405 31.8294 19.273L26.3744 16.038Z" fill="white"/>
</g>
<defs>
<clipPath id="clip0_6_0">
<rect width="136" height="29" fill="white"/>
</clipPath>
</defs>
</svg>
</a>

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

Shows all keys changed compared with `main` branch by default.
You can set the default branch by adding `config/credman.yml` file with `default_diff_branch: your_branch`
You can specify any branch from origin you want to. For example `credman diff my_branch`

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

Run it if you have merge conflicts in `configs/credentials/*.yml.enc`.
That interactive tool will help you resolve the conflict.
In most of cases it will just automagically resolve the conflicts.
In case of a key was changed in both branches it will ask you to choose the correct value.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Uscreen-video/credman.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
