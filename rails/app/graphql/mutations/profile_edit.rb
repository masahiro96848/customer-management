module Mutations
  class ProfileEdit < Mutations::BaseMutation
    argument :name, String, required: true
    argument :bio, String, required: false
    argument :image_url, String, required: false

    field :user, Types::UserType, null: false
    field :errors, [String], null: false

    def resolve(name:, bio: nil, image_url: nil)
      user = context[:current_user]
      return { user: nil, errors: ["User not authenticated"] } unless user

      image_file = nil
      if image_url
        image_file = decode_base64_image(image_url)
        user.image_url = image_file if image_file.present?
      end

      if user.update(name:, bio:, image_url: image_file)
        {
          user:,
          errors: [],
        }
      else
        {
          user: nil,
          errors: user.errors.full_messages,
        }
      end
    end

    private

      def decode_base64_image(image_url)
        body = image_url.split(",")[1]
        decoded_data = Base64.decode64(body)
        filename = "user_image_#{SecureRandom.uuid}.png"
        filepath = Rails.root.join("public", "uploads", filename)
        File.open(filepath, "wb") do |f|
          f.write(decoded_data)
        end
        File.open(filepath)
      end
  end
end
