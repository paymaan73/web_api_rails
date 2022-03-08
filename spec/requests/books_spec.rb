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

      describe "pagination" do
        context "when asking for the first page" do
          before { get('/api/books?page=1&per=2') }

          it 'receives HTTP status 200' do
            expect(response.status).to eq 200
          end

          it 'receives only tow books' do
            expect(json_body['data'].size).to eq 2
          end

          it 'receives a response with the Link header' do
            expect(response.headers['LINK'].split(', ').first).to eq(
                                                                    '<http://www.example.com/api/books?page=2&per=2>; rel="next"'
                                                                  )
          end
        end

        context 'when asking for the second page' do
          before { get('/api/books?page=2&per=2') }

          it 'receives HTTP status 200' do
            expect(response.status).to eq 200
          end

          it 'receives only one book' do
           expect(json_body['data'].size).to eq 1
          end
        end

        context "when sending invalid 'page' and 'per' parameters" do
          before { get('/api/books?page=fake&per=8') }

          it 'receives HTTP status 400' do
            expect(response.status).to eq(400)
          end

          it 'receives an error' do
            expect(json_body['error']).to_not be nil
          end

          it "receives 'page=fake' as an invalid param" do
            expect(json_body['error']['invalid_params']).to eq 'page=fake'
          end
        end
      end
    end # End of describe 'field picking'
  describe 'sorting' do
    it 'sorts the books by "id desc"' do
      get("/api/books?sort=id&dir=desc")
      expect(json_body['data'].first['id']).to eq agile_web_dev.id
      expect(json_body['data'].last['id']).to eq ruby_microscope.id
    end
  end

  context 'with invalid column name "fid"' do
    before { get '/api/books?sort=fid&dir=asc' }
    it 'gets "400 Bad Request" back' do
      expect(response.status).to eq 400
    end

    it 'receives an error' do
      expect(json_body['error']).to_not be nil
    end

    it 'receives "sort=fid" as an invalid param' do
      expect(json_body['error']['invalid_params']).to eq('sort=fid')
    end
  end

    context 'with invalid filtering param "q[ftitle_cont]=Microscope"' do
      before { get('/api/books?q[ftitle_cont]=Ruby') }

      it 'gets "400 Bad Request" back' do
        expect(response.status).to eq 400
      end

      it 'receives an error' do
        expect(json_body['error']).to_not be nil
      end

      it 'receives "q[ftitle_cont]=Ruby" as an invalid param' do
        expect(json_body['error']['invalid_params']).to eq 'q[ftitle_cont]=Ruby'
      end
    end

  end
end
