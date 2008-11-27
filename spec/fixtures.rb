require 'dm-sweatshop'

Forumtastic::User.fixture {{
  :name => name = /\w+/.gen,
  :email => "#{name}@email.com",
  :password => password = /\w+/.gen,
  :password_confirmation => password,
  :bio => /[:paragraph:]/.gen,
  :website => "http://#{/\w+/.gen}.com"
}}

Forumtastic::Forum.fixture {{
  :title => (2..7).of{ /\w+/.gen}.join(' '),
  :description => /[:sentence:]/.gen
}}

Forumtastic::Topic.fixture {{
  :title => (2..7).of{ /\w+/.gen}.join(' '),
  :forum => Forumtastic::Forum.all.pick,
  :user => Forumtastic::User.all.pick
}}

Forumtastic::Post.fixture {{
  :body => /[:paragraph:]/.gen,
  :user => Forumtastic::User.all.pick,
  :topic => Forumtastic::Topic.all.pick
}}