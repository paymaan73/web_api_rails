require "rails_helper"

RSpec.describe Paginator do
  let(:ruby_microscope) { create(:ruby_microscope) }
  let(:ruby_on_rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:agile_web_dev) { create(:agile_web_development) }
  let(:books) { [ruby_microscope, ruby_on_rails_tutorial, agile_web_dev] }

  let(:scope) { Book.all }
  let(:params) { { 'page' => '1', 'per' => '2' } }
  let(:paginator) { Paginator.new(scope, params, 'url') }
  let(:paginated) { paginator.paginate }

  before do
    books
  end

  describe '#paginate' do
    it 'paginates the collection with 2 books' do
      expect(paginated.size).to eq(2)
    end

    it 'contains ruby_microscope at the first paginated item' do
      expect(paginated.first).to eq ruby_microscope
    end

    it 'contains rails_tutorial as the last paginated item' do
      expect(paginated.last).to eq(ruby_on_rails_tutorial)
    end
  end

  describe "#links" do
    let(:links) { paginator.links.split(', ') }

    context 'when first page' do
      let(:params) { { 'page' => '1', 'per' => '2' } }

      it 'builds the "next" relation link' do
        expect(links.first).to eq '<url?page=2&per=2>; rel="next"'
      end

      it 'builds the "last" relation link' do
        expect(links.last).to eq('<url?page=2&per=2>; rel="last"')
      end

      context 'when last page' do
        let(:params) { { 'page' => '2', 'per' => '2' } }

        it 'builds the "first" relation link' do
          expect(links.first).to eq '<url?page=1&per=2>; rel="first"'
        end

        it 'builds the "previous" relation link' do
          expect(links.last).to eq '<url?page=1&per=2>; rel="prev"'
        end
      end
    end
  end # descirbe '#links' end
end
