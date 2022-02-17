# db/seeds.rb
pat = Author.create!(given_name: 'Pat', family_name: 'Shaughnessy')
michael = Author.create!(given_name: 'Michael', family_name: 'Hartl')
sam = Author.create!(given_name: 'Sam', family_name: 'Ruby')


oreilly = Publisher.create!(name: "O'Reilly")

Book.create!(title: 'Ruby Under a Microscope',
             subtitle: 'An Illustrated Guide to Ruby Internals',
             isbn_10: '1593275617',
             isbn_13: '9781593275617',
             description: 'Ruby Under a Microscope is a cool book!',
             released_on: '2013-09-01',
             publisher: oreilly,
             author: pat
            )


Book.create!(title: 'Ruby on Rails Tutorial',
            subtitle: 'Learn Web Development with Rails',
            isbn_10: '0134077709',
            isbn_13: '9780134077703',
            description: 'The Rails Tutorial is great!',
            released_on: '2013-05-09',
            publisher: oreilly,
            author: michael)

Book.create!(title: 'Agile Web Development with Rails 4',
            subtitle: '',
            isbn_10: '1937785564',
            isbn_13: '9781937785567',
            description: 'Stay agile!',
            released_on: '2015-10-11',
            publisher: oreilly,
            author: sam)
