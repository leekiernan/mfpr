#!/bin/bash /usr/local/bin/ruby

require "/app/config/capybara";
require "/app/config/db";

puts "Running"
User.all.each do |user|
  begin
    browser = Capybara.current_session
    browser.visit "https://www.myfitnesspal.com/account/login"

    browser.fill_in "username", with: user.email
    browser.fill_in "password", with: user.password
    browser.click_button "Log In"

    browser.visit "https://www.myfitnesspal.com/food/quick_add?meal=#{user.meal_to_append}"
    browser.all(".unit")[0].sibling("input").set "1"
    browser.click_button "Add to Diary"

    user.failed_attempts = 0
  rescue
    user.failed_attempts = user.failed_attempts + 1
  end

  if user.changed?
    user.save
  else
    user.touch
  end

  sleep 5
  Capybara.reset_sessions!
end

