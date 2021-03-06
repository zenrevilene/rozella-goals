# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :text
#  email           :text
#  password_digest :text
#  jarsCollection  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  dashboard_id    :integer
#

class User < ActiveRecord::Base
  has_secure_password
  has_many :goals
  belongs_to :dashboard

  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # Follows a user
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  #Unfollows a user
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  #Returns true if the current suer is following the other user
  def following?(other_user)
    following.include?(other_user)
  end

end
