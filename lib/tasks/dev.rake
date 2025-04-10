desc "Fill the database tables with some sample data"
task({ sample_data: :environment }) do
  puts "Creating sample data..."

  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end

  usernames = ["alice", "bob"]

  10.times { usernames << Faker::Internet.unique.username(specifier: 5..8) }

  usernames.each do |username|
    User.create!(
      email: "#{username}@example.com",
      password: "password",
      username: username,
      private: [true, false].sample,
      remote_avatar_image_url: "https://robohash.org/#{rand(10000)}?set=set4"
    )
  end

  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      next if first_user == second_user

      if rand < 0.75
        first_user.sent_follow_requests.create!(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample
        )
      end

      if rand < 0.75
        second_user.sent_follow_requests.create!(
          recipient: first_user,
          status: FollowRequest.statuses.keys.sample
        )
      end
    end
  end

  users.each do |user|
    rand(5..10).times do
      photo = user.own_photos.create!(
        caption: Faker::Quote.famous_last_words,
        remote_image_url: "https://robohash.org/#{rand(9999)}?set=set5"
      )

      user.followers.each do |follower|
        photo.fans << follower if rand < 0.5

        if rand < 0.25
          photo.comments.create!(
            body: Faker::Quote.famous_last_words,
            author: follower
          )
        end
      end
    end
  end

  puts "Sample data created!"
  puts "Users: #{User.count}"
  puts "Follow Requests: #{FollowRequest.count}"
  puts "Photos: #{Photo.count}"
  puts "Likes: #{Like.count}"
  puts "Comments: #{Comment.count}"
end
