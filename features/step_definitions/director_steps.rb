When /^I choose yesterday for the date of election$/ do
  yesterday = 1.day.ago
  select(yesterday.year.to_s, :from => 'director[elected_on(1i)]')
  select(yesterday.strftime('%B'), :from => 'director[elected_on(2i)]')
  select(yesterday.day.to_s, :from => 'director[elected_on(3i)]')
end

When /^I check the certification checkbox$/ do
  check('director[certification]')
end

When /^I press "([^"]*)" for another director$/ do |button|
  @director = @company.members.where(["id <> ?", @user.id]).first
  within("tr#director_#{@director.id}") do
    click_button(button)
  end
end

Then /^I should see a form for standing down the director$/ do
  page.should have_selector("form[action='/directors/#{@director.id}/stand_down']")
  within("form[action='/directors/#{@director.id}/stand_down']") do
    page.should have_selector("select[name='director[stood_down_on(1i)]']")
    page.should have_selector("select[name='director[stood_down_on(2i)]']")
    page.should have_selector("select[name='director[stood_down_on(3i)]']")
    page.should have_selector("input[name='director[certification]']")
    page.should have_selector("input[type=submit]")
  end
end

When /^I submit the form to stand down the director$/ do
  yesterday = 1.day.ago
  within("form[action='/directors/#{@director.id}/stand_down']") do
    select(yesterday.year.to_s, :from => 'director[stood_down_on(1i)]')
    select(yesterday.strftime('%B'), :from => 'director[stood_down_on(2i)]')
    select(yesterday.day.to_s, :from => 'director[stood_down_on(3i)]')
    check('director[certification]')
    click_button("Stand this director down")
  end
end

When /^I add a new director$/ do
  When 'I go to the Directors page'
  And 'I press "Add a new director"'
  And 'I fill in "Email" with "bob@example.com"'
  And 'I fill in "First name" with "Bob"'
  And 'I fill in "Last name" with "Smith"'
  And 'I choose yesterday for the date of election'
  And 'I check the certification checkbox'
  And 'I press "Add this director"'
end

When /^I stand down a director$/ do
  Given 'I am on the Directors page'
  When 'I press "Stand down" for another director'
  When 'I submit the form to stand down the director'
end

Then /^I should not see the director$/ do
  page.should_not have_selector("tr#director_#{@director.id}")
end
