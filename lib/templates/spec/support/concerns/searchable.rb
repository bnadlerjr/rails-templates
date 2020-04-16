RSpec.shared_examples_for 'searchable' do
  it 'is searchable?' do
    expect(described_class.searchable?).to eq(true)
  end

  it 'has a #search method' do
    expect(described_class).to respond_to(:search)
  end
end
