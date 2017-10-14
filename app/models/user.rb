class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
				 :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :name, presence: true
	validates_format_of :email, with: /\.edu/, message: 'Your email should contain .edu '


	has_attached_file :avatar, :styles => { :medium => "1000x00>", :thumb => "40x40#" }, :default_url => "/images/:style/missing.png"
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/




	def feed
		Post.all.order(created_at: :desc)
	end

	def generate_access_token
		generated = SecureRandom.hex

		until User.where(access_token: generated).first.nil?
			generated = SecureRandom.hex
		end
		self.access_token = generated
		save!
	end



end
