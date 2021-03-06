# AtCoderVcFriends

AtCoderVcFriends automates tasks about [AtCoder Virtual Contest](https://not-522.appspot.com/) programming contest such as:

- Download example input/output
- Generate source skeleton
- Run test cases
- Submit code

## Dependencies

- Ruby 2.4 or newer
- [AtCoderFriends](https://github.com/nejiko96/at_coder_friends/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'at_coder_vc_friends'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install at_coder_vc_friends

## Usage

### Setup

```
at_coder_vc_friends setup         /path/to/contest contest_url
```

Creates contest folder, and generates example data and source skeletons into the folder.

### Run first test case

```
at_coder_vc_friends test-one      /path/to/contest/source_file
```

### Run all test cases

```
at_coder_vc_friends test-all      /path/to/contest/source_file
```

### Submit code

```
at_coder_vc_friends submit        /path/to/contest/source_file
```

### Submit code automatically if all tests passed

```
at_coder_vc_friends check-and-go  /path/to/contest/source_file
```

### Naming convention

- Source file should be named ```[contest ID]#[problem ID].[language specific extension]```(e.g. ```arc001#A.rb```),
  in order to let AtCoderVcFriends find test cases or fill the submission form.
- Suffixes (start with underscore) may be added to the file name (e.g. ```arc001#A_v2.rb```),
  so that you can try multiple codes for one problem.

## Configuration

See [AtCoderFriends documentation](https://github.com/nejiko96/at_coder_friends/blob/master/docs/CONFIGURATION.md) for details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 

<!-- To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org). -->

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/at_coder_vc_friends. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/at_coder_vc_friends/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AtCoderVcFriends project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/at_coder_vc_friends/blob/master/CODE_OF_CONDUCT.md).
