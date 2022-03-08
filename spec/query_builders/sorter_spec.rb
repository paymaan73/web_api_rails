require "rails_helper"

RSpec.describe Sorter do
  let(:ruby_microscope) { create(:ruby_microscope) }
  let(:rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:agile_web_dev) { create(:agile_web_development) }
  let(:books) { [ruby_microscope, rails_tutorial, agile_web_dev] }

  let(:scope) { Book.all }
  let(:params) { HashWithIndifferentAccess.new({ sort: 'id', dir: 'desc' }) }
  let(:sorter) { Sorter.new(scope, params) }
  let(:sorted) { sorter.sort }

  before do
    allow(BookPresenter).to(
      receive(:sort_attributes).and_return(['id', 'title'])
    )
    books
  end

  describe '#sort' do
    context 'without any parameters' do
      let(:params) { {} }
      it 'returns the scope unchanged' do
        expect(sorted).to eq scope
      end
    end

    context 'with valid parameters' do
      it 'sorts the collection by "id" desc' do
        expect(sorted.first.id).to eq agile_web_dev.id
        expect(sorted.last.id).to eq ruby_microscope.id
      end

      it 'sorts the collection by "title asc"' do
        expect(sorted.first).to eq agile_web_dev
        expect(sorted.last).to eq ruby_microscope
      end
    end

    context 'with invalid parameters' do
      let(:params) { HashWithIndifferentAccess.new({ sort: 'fid', dir: 'desc' })}
      it 'raises a QueryBuilderError exception' do
        expect { sorted }.to raise_error(QueryBuilderError)
      end
    end
  end
end
