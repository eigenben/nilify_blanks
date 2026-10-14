# Changelog

## 2.0.0 (2026-10-14)

* Require Rails 6.1+ and Ruby 2.7+ (tested on Rails 6.1 through 8.1)
* RSpec matchers no longer define helper methods on every object, and drop RSpec 1/2 compatibility
* Remove legacy Rails 2 plugin files (`init.rb`, `rails/init.rb`)
* Replace Travis CI and Appraisal with GitHub Actions
* Only package library files in the gem, and add RubyGems metadata
* Convert README and CHANGELOG to Markdown, and document when Rails' built-in `normalizes` is a better fit

## 1.4.0 (2020-04-18)

* Internally restructure NilifyBlanks, use modern tooling like ActiveSupport::Concern
* Drop support for Rails 3, expand Appraisals to include Rails 6
* Change default before callback to :validation (from :save)

## 1.3.0 (2017-12-23)

* Use all columns (not just content_columns)
* Allow nullables_only: false option for including columns that don't allow NULLs
* Support citext columns

## 1.2.1 (2015-04-12)

* Fix inconsistency in nilify_blanks RSpec matcher: should filter by type

## 1.2.0 (2014-07-04)

* Drop support for ruby 1.8.7 and 1.9.2 - too many issues with backwards-compatibility
* Explicit support for Rails 4.1 and 4.2
* Up-to-date Appraisals and dependencies

## 1.1.0 (2014-07-04)

* Implement new mechanism to allow for global usage at ActiveRecord::Base level (or namespaced base model)
* Make define_nilify_blanks thread safe
* New rspec matchers with: require "nilify_blanks/matchers"
* Only consider string and text columns, and allow types option to configure

## 1.0.4 (2013-11-09)

* Fix issues with wrapping define_attribute_methods in jruby on Rails 4 (Thanks, tank157)

## 1.0.3 (2013-11-09)

* Add rbx and JRuby compatibility (Thanks, petergoldstein)

## 1.0.2 (2013-08-25)

* Hook on AR::Base.define_attribute_methods in order to prevent eager load of models [byroot]

## 1.0.0 (2010-10-15) - Major Updates

* Finally updated to be a Gem
* Internal refactoring
* Converted tests to RSpec
* Added support for Rails 3.0

## 0.1.2

* Fixed issue with table not existing.

## 0.1.0

* Initial Version
