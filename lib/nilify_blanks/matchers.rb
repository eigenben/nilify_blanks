require "rspec/expectations"

RSpec::Matchers.define :nilify_blanks_for do |column_name, options = {}|
  match do |model_instance|
    model_class = model_instance.class
    model_class.define_attribute_methods
    model_class.include?(NilifyBlanks) &&
    model_class.nilify_blanks_columns.include?(column_name.to_s) &&
    options.all? {|k, v| (model_class.nilify_blanks_options || {})[k] == v }
  end

  failure_message do
    "expected to nilify blanks for #{column_name}#{" #{options.inspect}" unless options.empty?}"
  end

  failure_message_when_negated do
    "expected to not nilify blanks for #{column_name}#{" #{options.inspect}" unless options.empty?}"
  end
end

RSpec::Matchers.define :nilify_blanks do |options = {}|
  match do |model_instance|
    expected_types = options[:types] ? Array.wrap(options[:types]).map(&:to_sym) : NilifyBlanks::ClassMethods::DEFAULT_TYPES

    model_class = model_instance.class
    model_class.define_attribute_methods
    model_class.include?(NilifyBlanks) &&
    model_class.nilify_blanks_columns == model_class.columns.select(&:null).select {|c| expected_types.include?(c.type) }.map(&:name).map(&:to_s) &&
    options.all? {|k, v| (model_class.nilify_blanks_options || {})[k] == v }
  end

  failure_message do
    "expected to nilify blanks#{" #{options.inspect}" unless options.empty?}"
  end

  failure_message_when_negated do
    "expected to not nilify blanks#{" #{options.inspect}" unless options.empty?}"
  end
end
