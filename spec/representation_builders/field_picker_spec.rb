require "rails_helper"

RSpec.describe FieldPicker do
  # We define 'let' in cascade where each one of them is used by the
  # one below. This allows us to override any of them easily in a
  # specific context.
  let(:rails_tutorial) { create(:ruby_on_rails_tutorial) }
  let(:params) { { fields: 'id,title,subtitle' } }
  let(:presenter){ BookPresenter.new(rails_tutorial, params) }
  let(:field_picker) { FieldPicker.new(presenter) }

  # We don't want our tests to rely too much on the actual implementation of
  # the book presenter. Instead, we stub the method 'build_attributes'
  # on BookPresenter to always return the same list of attributes for
  # the tests in this file

  before do
    allow(BookPresenter).to(
      receive(:build_attributes).and_return(['id', 'title', 'author_id'])
    )
  end

  # Pick is the main method of the FieldPicker. It's meant to be used
  # as 'FieldPicker.new(presenter).pick and should return the same presenter'
  # with updated data
  describe '#pick' do
    context 'with the "fields" parameter containing "id,title,subtitle"' do
      it 'updates the presenter "data" with the book "id" and "title"' do
        expect(field_picker.pick.data).to eq({
                                            'id' => rails_tutorial.id,
                                            'title' => 'Ruby on Rails Tutorial'
                                             })
      end
      context 'with overriding method defined in presenter' do
        # In this case, we want the presenter to have the method 'title'
        # in order to test the overriding system. To do this, the simplest
        # solution is to meta-programmatically add it.
        before { presenter.class.send(:define_method, :title) { 'Overridden!' } }

        it 'updates the presenter "data" with the title "Overridden!"' do
          expect(field_picker.pick.data).to eq({
            'id' => rails_tutorial.id,
            'title' => 'Overridden!'
          })
        end

        # Let's not forget to remove the method once we're done to
        # avoid any problem with other tests. Always clean up after your tests!
        after { presenter.class.send(:remove_method, :title) }
      end
    end
    context 'with no "fields" parameter' do
      # I mentioned earlier how we can easily override any 'let'.
      # Here we just override the 'params' let which will be used in place
      # of the one we created earlier, but only in this context
      let(:params) { {} }

      it 'updates "data" with the fields ("id","title","author_id")' do
        expect(field_picker.send(:pick).data).to eq({
          'id' => rails_tutorial.id,
          'title' => 'Ruby on Rails Tutorial',
          'author_id' => rails_tutorial.author.id
        })
      end
    end
  end
end
