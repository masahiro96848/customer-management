module Mutations
  class PostSort < Mutations::BaseMutation
    # 戻り値の定義
    field :posts, [Types::PostType], null: false

    # ソートとページネーションに使用する引数の定義
    argument :sort_by, String, required: true, description: "ソート基準: 'created_at' または 'favorites_count'"
    argument :order, String, required: true, description: "ソート順: 'asc' または 'desc'"
    argument :limit, Integer, required: false, description: "取得する記事の最大数"
    argument :offset, Integer, required: false, description: "取得する記事のオフセット"

    def resolve(sort_by:, order:, limit: nil, offset: nil)
      sort_order = (order.downcase == "asc") ? :asc : :desc

      posts = case sort_by
              when "created_at"
                Post.order(created_at: sort_order)
              when "favorites_count"
                Post.left_joins(:favorites).
                  group(:id).
                  order("COUNT(favorites.id) #{sort_order}")
              else
                Post.order(created_at: :desc) # デフォルトは作成日順
              end

      posts = posts.limit(limit) if limit
      posts = posts.offset(offset) if offset

      { posts: }
    end
  end
end
