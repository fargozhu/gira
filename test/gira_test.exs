defmodule GiraTest do
  use ExUnit.Case

  # add Jira base url like https://jira.com/rest/api/2
  @base_url System.get_env("JIRA_BASE_URL")
  # add Jira authorization token here
  @authorization_token System.get_env("JIRA_AUTH_TOKEN")

  test "returns { :ok, { status: 200, payload: %{} }} when creating a Jira issue" do
    request_body = %{
      fields: %{
        project: %{
          key: "CAP"
        },
        customfield_17101: %{
          name: "jaimegomes"
        },
        summary: "REST ye merry gentlemen.",
        description:
          "Creating of an issue using project keys and issue type names using the REST API",
        issuetype: %{
          id: "10"
        },
        reporter: %{
          name: "jaimegomes"
        },
        labels: [
          "EMEA",
          "Github-1210"
        ]
      }
    }

    client = Gira.new(@base_url, @authorization_token)
    {:ok, response} = Gira.create_issue_with_basic_info(client, request_body)

    assert response.status == 200
    assert response.payload != nil
  end

  test "returns issue basic info as { :ok, { status: 200, payload: [%{}] }} when searching for an existent issue" do
    client = Gira.new(@base_url, @authorization_token)
    {:ok, response} = Gira.get_issue_basic_info_by_query(client, "labels%3DGithub-1210")

    assert response.status == 200
    assert response.payload != nil
    assert Enum.map(response.payload["issues"], & &1["id"]) > 0
  end

  @tag :skip
  test "it returns { :ok, { status: 200, payload: %{} }} when closing a Jira issue" do
    client = Gira.new(@base_url, @authorization_token)
    {:ok, response} = Gira.close_issue(client, @id)

    assert response.status == 200
    assert response.payload != nil
  end

  @tag :skip
  test "it returns { :ok, { status: 200, payload: %{} }} when adding a comment to an existent Jira issue" do
    client = GiraClient.new(@base_url, @authorization_token)
    {:ok, response} = Gira.add_comment_to_issue(client, @id, @comment)

    assert response.status == 200
    assert response.payload != nil
  end
end
