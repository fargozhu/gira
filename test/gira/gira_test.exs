defmodule GiraTest do
  use ExUnit.Case  

  @base_url ""  # add Jira base url like https://jira.com/rest/api/2
  @auth_token ""  # add Jira authorization token here

  # Application.put_env(:tesla, Tesla.MockTest.Client, adapter: Tesla.Mock)    

  test "it returns issue basic info as { :ok, { status: 200, payload: [%{}] }} when searching for an existent issue" do
    { :ok, response } = Gira.get(
      @base_url <> "/search?jql=labels%3DGithub-1210&fields=total", 
      [{ "Authorization",  @auth_token }, { "Content-type", "application/json" }])        

    assert response.status == 200
    assert response.payload != nil
    assert Enum.map(response.payload, & &1["id"]) > 0
  end
  
  test "it returns a { :ok, { status: 404, payload: nil }} when searching for an unexistent issue" do
    { :ok, response } = Gira.get(        
      @base_url <> "/search?jql=labels%3DGithub-NotExist&fields=total", 
      [{ "Authorization",  @auth_token }, { "Content-type", "application/json" }])        
    
    assert response.status == 404
    assert response.payload == nil
  end

  @tag :skip
  test "it returns { s:ok, { status: 200, payload: %{} }} when creating a Jira issue" do
    { :ok, response } = Gira.create_issue()
    assert response.status == 200
    assert response.payload != nil
  end

  @tag :skip
  test "it returns { :ok, { status: 200, payload: %{} }} when closing a Jira issue" do
      { :ok, response } = Gira.close_issue("12345")
      assert response.status == 200
      assert response.payload != nil
  end

  @tag :skip
  test "it returns { :ok, { status: 200, payload: %{} }} when adding a comment to an existent Jira issue" do
    { :ok, response } = Gira.add_comment_to_issue()
    assert response.status == 200
    assert response.payload != nil
  end
end
