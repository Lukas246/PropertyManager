require "test_helper"

class AssetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @asset = assets(:one)
  end

  test "should get index" do
    get assets_url
    assert_response :success
  end

  test "should get new" do
    get new_asset_url
    assert_response :success
  end

  test "should create asset" do
    assert_difference("Asset.count") do
      post assets_url, params: { asset: { code: @asset.code, last_inspection_date: @asset.last_inspection_date, name: @asset.name, note: @asset.note, purchase_date: @asset.purchase_date, purchase_price: @asset.purchase_price, room_id: @asset.room_id } }
    end

    assert_redirected_to asset_url(Asset.last)
  end

  test "should show asset" do
    get asset_url(@asset)
    assert_response :success
  end

  test "should get edit" do
    get edit_asset_url(@asset)
    assert_response :success
  end

  test "should update asset" do
    patch asset_url(@asset), params: { asset: { code: @asset.code, last_inspection_date: @asset.last_inspection_date, name: @asset.name, note: @asset.note, purchase_date: @asset.purchase_date, purchase_price: @asset.purchase_price, room_id: @asset.room_id } }
    assert_redirected_to asset_url(@asset)
  end

  test "should destroy asset" do
    assert_difference("Asset.count", -1) do
      delete asset_url(@asset)
    end

    assert_redirected_to assets_url
  end
end
