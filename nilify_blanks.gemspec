require_relative "lib/nilify_blanks/version"

Gem::Specification.new do |s|
  s.name        = "nilify_blanks"
  s.version     = NilifyBlanks::VERSION
  s.license     = "MIT"
  s.author      = "Ben Hughes"
  s.email       = "me@benhughes.name"
  s.homepage    = "https://github.com/eigenben/nilify_blanks"
  s.summary     = "Auto-convert blank fields to nil."
  s.description = "Often times you'll end up with empty strings where you really want nil at the database level.  This plugin automatically converts blanks to nil and is configurable."

  s.metadata = {
    "source_code_uri"       => "https://github.com/eigenben/nilify_blanks",
    "changelog_uri"         => "https://github.com/eigenben/nilify_blanks/blob/master/CHANGELOG.md",
    "bug_tracker_uri"       => "https://github.com/eigenben/nilify_blanks/issues",
    "rubygems_mfa_required" => "true"
  }

  s.files        = Dir["lib/**/*", "CHANGELOG*", "LICENSE", "README*"]
  s.require_path = "lib"

  s.required_ruby_version = ">= 2.7"

  s.add_dependency("activesupport", [">= 6.1"])
  s.add_dependency("activerecord", [">= 6.1"])
end
