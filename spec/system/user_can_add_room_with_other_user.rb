require 'rails_helper'

RSpec.describe "Room Management", type: :system do
  let!(:user) { User.create!(email: "test@example.com", password: "password", username: "testuser") }
  let!(:another_user) { User.create!(email: "another_user@example.com", password: "password", username: "another") }
  

  before do
    login_as(user, scope: :user)
  end

  it 'allows a user to create a room and add another user' do
    visit root_path

    # Step 1: Fill in room name
    fill_in 'room_name', with: 'Test Room'

    puts "another_user.id: #{another_user.id}"
    puts "Errors: #{another_user.errors.full_messages}" if another_user.errors.any?
    
    # Step 2: Check the checkbox for the other user to add to the room
    find("input[type='checkbox'][value='#{another_user.id}']").set(true)
    
    # Step 3: Submit the form to create the room
    click_button 'Create Room'
    
    # Step 4: Verify that the room was created
    expect(page).to have_content('Test Room')

    visit root_path
    
    # Step 5: Log out the current user (who created the room)
    expect(page).to have_button('Sign out')
    click_button 'Sign out'

    # Step 6: Log in as the added user
    login_as(another_user, scope: :user)

    # Step 7: Visit the rooms page and verify that the user can see the room
    visit root_path

    # Step 8: Verify that the room is visible to the added user
    expect(page).to have_content('Test Room') 
  end
end