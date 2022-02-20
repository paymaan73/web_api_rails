require "rails_helper"

RSpec.describe 'Books', type: :request do
  # one let for each book factory. Here we use 'create' instead
  # of 'build' because we need the data persisted. Those two methods
  # are provided by Factory Girl
  let(:ruby_microscope) { create(:ruby_microscope) }
  let(:rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:agile_web_dev) { create(:agile_web_development) }

  # Putting them in an array make it easier to create them in one line
  let(:books) { [ruby_microscope, rails_tutorial, agile_web_dev] }

  let(:json_body) { JSON.parse(response.body) }

  describe 'GET /api/books' do
    # Before any test, let's create our 3 books
    before { books }

    context 'default behavior' do
      before { get '/api/books' }

      it 'gets HTTP status 200' do
        expect(response.status).to eq 200
      end

      it 'receives a json with the "data" root key' do
        expect(json_body['data']).to_not be nil
      end

      it 'recevies all 3 books' do
        expect(json_body['data'].size).to eq 3
      end
    end

    describe 'field picking' do
      context 'with the fields parameters' do
        before { get '/api/books?fields=id,title,author_id' }

        it 'gets books with only the id, title and author_id keys' do
          json_body['data'].each do |book|
            expect(book.keys).to eq(['id', 'title', 'author_id'])
          end
        end
      end

      context 'without the "fields" parameters' do
        before { get '/api/books' }

        it 'gets books with all the fields specified in the presenter' do
          json_body['data'].each do |book|
            expect(book.keys).to eq BookPresenter.build_attributes.map(&:to_s)
          end
        end
      end
    end # End of describe 'field picking'
  end
end
