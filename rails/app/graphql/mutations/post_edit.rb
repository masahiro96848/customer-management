module Mutations
  class PostEdit < Mutations::BaseMutation
    argument :title, String, required: true
    argument :body, String, required: false
    argument :image_url, String, required: false
    argument :uid, String, required: true
    argument :is_published, Int, required: true

    field :post, Types::PostType, null: false
    field :errors, [String], null: false

    def resolve(title:, uid:, is_published:, body: nil, image_url: nil)
      user = context[:current_user]
      return { post: nil, errors: ["User not authenticated"] } unless user

      post = user.posts.find_by(uid:)

      if post
        if image_url
          image_data = decode_base64_image(image_url)
          post.image_url = image_data if image_data
        end

        if post.update(title:, body:, is_published:)
          { post:, errors: [] }
        else
          { post: nil, errors: post.errors.full_messages }
        end
      else
        image_data = decode_base64_image(image_url) if image_url
        post = user.posts.new(
          title:,
          body:,
          image_url: image_data,
          is_published:,
          uid:,
        )

        if post.save
          { post:, errors: [] }
        else
          { post: nil, errors: post.errors.full_messages }
        end
      end
    end

    private

      def decode_base64_image(image_url)
        body = image_url.split(",")[1]
        decoded_data = Base64.decode64(body)
        filename = "image_#{SecureRandom.uuid}.png"
        filepath = Rails.root.join("public", "uploads", filename) # 'public/uploads'ディレクトリに保存
        File.open(filepath, "wb") do |f|
          f.write(decoded_data)
        end
        File.open(filepath)
      end
  end
end
