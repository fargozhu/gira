defmodule Gira.GiraWrapperTest do
  use ExUnit.Case

  # add Jira base url like https://jira.com/rest/api/2
  @base_url System.get_env("JIRA_BASE_URL")
  # add Jira authorization token here
  @auth_token System.get_env("JIRA_AUTH_TOKEN")
  @headers [{"Authorization", @auth_token}, {"Content-type", "application/json"}]

  test "it returns issue basic info as { :ok, { status: 200, payload: [%{}] }} when searching for an existent issue" do
    {:ok, response} =
      Gira.GiraWrapper.get(@base_url <> "/search?jql=labels%3DGithub-1210&fields=total", @headers)

    assert response.status == 200
    assert response.payload != nil
    assert Enum.map(response.payload["issues"], & &1["id"]) > 0
  end

  test "it returns a { :ok, { status: 404, payload: nil }} when searching for an unexistent issue" do
    {:ok, response} =
      Gira.GiraWrapper.get(
        @base_url <> "/search?jql=labels%3DGithub-UnknownIssue&fields=total",
        @headers
      )

    assert response.status == 404
    assert response.payload == nil
  end

  test "it returns a { :ok, { status: 200, payload: %{} }} when creating a new issue" do
    jira = %{
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
          "Github-9999"
        ]
      }
    }

    {:ok, response} = Gira.GiraWrapper.post(@base_url <> "/issue", jira, @headers)
    assert response.status == 200
    assert response.payload != nil
  end
end
