require "rails_helper"

RSpec.describe "Api::V1::Test", type: :request do
  describe "GET api/v1/test" do
    subject { get(api_v1_test_path) }

    it "正常にレスポンスが返る" do
      subject
      res = JSON.parse(response.body)
      expect(res["message"]).to eq "Success Test Check!"
      expect(response).to have_http_status(:success)
    end
  end
end
