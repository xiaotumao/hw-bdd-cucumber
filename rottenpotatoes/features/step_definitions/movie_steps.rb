Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(title: movie[:title],
                 rating: movie[:rating],
                 release_date: movie[:release_date],
                )
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  expect(page.body).to have_content(/#{e1}.*#{e2}/)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  trigger = uncheck
  rating_list.split(',').each do |rating|
    trigger ? uncheck("ratings_#{rating}") : check("ratings_#{rating}")
  end
end

Then /I should see all movies with ratings: (.*)/ do |rating_list|
  ratings = page.all('#movies tbody tr td:nth-child(2)').map(&:text)
  rating_list.split(',').each do |rating|
    expect(ratings).to have_content(rating)
  end
end

Then /I should not see movies with ratings: (.*)/ do |rating_list|
  ratings = page.all('#movies tbody tr td:nth-child(2)').map(&:text)
  rating_list.split(',').each do |rating|
    expect(ratings).not_to have_content(/\A#{rating}/)
  end
end

Then /I should see all the movies/ do
  number_of_movies = Movie.count
  expect(page).to have_css('#movies tbody tr', count: number_of_movies)
end