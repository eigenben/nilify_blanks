# Nilify Blanks

[![CI](https://github.com/rubiety/nilify_blanks/actions/workflows/ci.yml/badge.svg)](https://github.com/rubiety/nilify_blanks/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/nilify_blanks.svg)](https://rubygems.org/gems/nilify_blanks)

In Rails when saving a model from a form and values are not provided by the user, an empty string is recorded to the database instead of a NULL as many would prefer (mixing blanks and NULLs can become confusing). This gem converts blank attributes to nil before a model is saved, either for every applicable column or for a list you choose.

By default, columns set as NOT NULL will not be nilified, since that value cannot be persisted, and it might be better to catch that with a validation. If you want to nilify those columns anyway, you can use `only:` (see below) to explicitly mention them.

Only attributes responding to `blank?` with a value of true will be converted to nil. Therefore, this does not work with integer fields with the value of 0, for example.

## Do you need this gem?

Rails 7.1 added [`normalizes`](https://api.rubyonrails.org/classes/ActiveRecord/Normalization/ClassMethods.html), which handles the per-attribute case well:

```ruby
class Post < ApplicationRecord
  normalizes :title, :author, with: ->(value) { value.presence }
end
```

`normalizes` applies on assignment (not just before save) and to finder queries like `where(title: "")`, so prefer it when you only care about a few attributes.

Use nilify_blanks when you want this behavior for **every** nullable string/text column without listing them, including columns added later, or across all models at once via `ApplicationRecord` or `ActiveRecord::Base`.

## Requirements

* Rails (Active Record) 6.1 or newer
* Ruby 2.7 or newer

Version 1.4.0 remains available for older Rails versions.

## Install

Add the gem to your Gemfile:

```ruby
gem "nilify_blanks"
```

## Basic Usage

```ruby
# Checks and converts all nullable string, text and citext columns
class Post < ApplicationRecord
  nilify_blanks
end

# Checks and converts only text columns
class Post < ApplicationRecord
  nilify_blanks types: [:text]
end

# Checks and converts only the title and author fields
class Post < ApplicationRecord
  nilify_blanks only: [:author, :title]
end

# Checks and converts all fields except for title and author
class Post < ApplicationRecord
  nilify_blanks except: [:author, :title]
end

# Checks and converts any fields, regardless of their null constraint
class Post < ApplicationRecord
  nilify_blanks nullables_only: false
end
```

## Global Usage

You can apply nilify_blanks to every model in your application:

```ruby
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  nilify_blanks
end
```

Or to all models inheriting from `ActiveRecord::Base`:

```ruby
ActiveRecord::Base.nilify_blanks
```

Or perhaps just a model namespace base class:

```ruby
Inventory::Base.nilify_blanks
```

Individual models can still call `nilify_blanks` with their own options to override the inherited configuration.

## Specifying a Callback

Checking uses an Active Record `before_validation` callback by default, but you can specify a different callback with the `:before` option. Any `before_*` callback will work; just remove the `before_` prefix from the name.

```ruby
class Post < ApplicationRecord
  nilify_blanks before: :save
end

class Post < ApplicationRecord
  nilify_blanks before: :create
end
```

## RSpec Matchers

First, include the matchers:

```ruby
require "nilify_blanks/matchers"
```

To ensure for a given column:

```ruby
RSpec.describe City do
  it { is_expected.to nilify_blanks_for(:name) }
end
```

To ensure for all applicable content columns:

```ruby
RSpec.describe City do
  it { is_expected.to nilify_blanks }
end
```

You can optionally match on options also:

```ruby
RSpec.describe City do
  it { is_expected.to nilify_blanks_for(:name, before: :create) }
  it { is_expected.to nilify_blanks(before: :create) }
end
```

## Running Tests

```
bundle install
bundle exec rake
```

CI runs the suite against each supported Rails version using the gemfiles in `gemfiles/`. To run against one locally:

```
BUNDLE_GEMFILE=gemfiles/rails_7.2.gemfile bundle install
BUNDLE_GEMFILE=gemfiles/rails_7.2.gemfile bundle exec rake
```
