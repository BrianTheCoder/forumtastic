DataMapper.auto_migrate!
require Merb.root / 'spec' / 'fixtures'

puts "Generating Users"
200.times { Forumtastic::User.gen }

puts "Generating Forums"
10.times { Forumtastic::Forum.gen }

puts "Generating Topics"
200.times { Forumtastic::Topic.gen }

puts "Generating Post"
1000.times { Forumtastic::Post.gen }