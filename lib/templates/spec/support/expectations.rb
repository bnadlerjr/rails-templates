RSpec::Matchers.define :have_searchable_attributes do |*expected|
  match do
    expected.sort == described_class.searchable_columns.sort
  end

  failure_message do
    "expected that #{described_class.searchable_columns} would match #{expected}"
  end
end
