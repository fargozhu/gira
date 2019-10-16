defmodule Gira do
    @base_url "https://<jira-url>" <> "/rest/api/2"

    # Get the Jira issue id using runtime JQL
    def get_issue_basic_info(query, headers \\ []) do        
        HTTPoison.get(@base_url <> "/search?jql=" <> query <> "&maxResults=1&fields=total", headers)        
        |> decode_response     
        |> IO.inspect           
        |> handle_response
    end

    def create_issue(data, headers \\ []) do
        { :ok, %{ :status => 200, :body => %{ :id => 1234, :name => "CAP-1234" }}}
    end

    def close_issue(data, headers \\ []) do
        { :ok, %{ :status => 200, :body => %{ :id => 1234, :name => "CAP-1234" }}}
    end

    def add_comment_to_issue(comment, id, headers \\ []) do    
        { :ok, %{ :status => 200, :body => %{ :id => 1234, :name => "CAP-1234" }}}
    end
    
    defp decode_response({ :ok, %HTTPoison.Response{ status_code: status, body: body}}) do           
        case Jason.decode(body) do
          { :ok, decoded } -> { :ok, decoded }
          { :error, error } -> { :error, %{ status: 500, payload: error }}
        end        
    end 

    defp handle_response(resp = { :error, %{ payload: payload}}) do        
        { :ok, %{ status: 500, payload: payload}}
    end

    defp handle_response(resp = { :ok, %{ "total" => 0 }}) do
        { :ok, %{ status: 404, payload: nil}}
    end

    defp handle_response({ :ok, resp = %{ "issues" => [%{}] }}) do
        { :ok, %{ status: 200, payload: resp["issues"] }}
    end
end
