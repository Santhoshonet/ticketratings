require 'test_helper'

class RankcriteriasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rankcriterias)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rankcriteria" do
    assert_difference('Rankcriteria.count') do
      post :create, :rankcriteria => { }
    end

    assert_redirected_to rankcriteria_path(assigns(:rankcriteria))
  end

  test "should show rankcriteria" do
    get :show, :id => rankcriterias(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => rankcriterias(:one).to_param
    assert_response :success
  end

  test "should update rankcriteria" do
    put :update, :id => rankcriterias(:one).to_param, :rankcriteria => { }
    assert_redirected_to rankcriteria_path(assigns(:rankcriteria))
  end

  test "should destroy rankcriteria" do
    assert_difference('Rankcriteria.count', -1) do
      delete :destroy, :id => rankcriterias(:one).to_param
    end

    assert_redirected_to rankcriterias_path
  end
end
