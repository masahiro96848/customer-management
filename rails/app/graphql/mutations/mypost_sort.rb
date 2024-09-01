module Mutations
  class MypostSort < Mutations::BaseMutation
    # 戻り値の定義
    field :myposts, [Types::PostType], null: false

    # ソートとページネーションに使用する引数の定義
    argument :sort_by, String, required: true, description: "ソート基準: 'created_at', 'is_published'"
    argument :order, String, required: true, description: "ソート順: 'asc' または 'desc'"
    argument :limit, Integer, required: false, description: "取得する記事の最大数"
    argument :offset, Integer, required: false, description: "取得する記事のオフセット"

    def resolve(sort_by:, order:, limit: nil, offset: nil)
      sort_order = (order.downcase == "asc") ? :asc : :desc

      user = context[:current_user]
      return { myposts: [] } unless user

      # 自分の投稿のみを取得
      myposts = user.posts

      if sort_by == "is_published"
        myposts = myposts.where(is_published: (sort_order == :asc) ? 2 : 1)
      end

      myposts = myposts.order(sort_by.to_sym => sort_order)
      myposts = myposts.limit(limit) if limit
      myposts = myposts.offset(offset) if offset

      { myposts: }
    end
  end
end
