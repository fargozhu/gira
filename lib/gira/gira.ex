defmodule Gira do
    use HTTPoison.Base
    @endpoint ""

    def process_url(url) do
        @endpoint <> url
    end


    #defp process_response(body), do: IO.inspect body

    # called before returning response body back the caller
    def process_response(%HTTPoison.Response{ status_code: status_code, body: body })  when status_code in [200] do    
        body        
        |> parse_body
        |> handle_response
    end

    def process_response(%HTTPoison.Error{ reason: { _, reason }}), do: { :error, reason }

    def create_issue(data, headers \\ []) do
        { :ok, %{ :status => 200, :body => %{ :id => 1234, :name => "CAP-1234" }}}
    end

    def close_issue(data, headers \\ []) do
        { :ok, %{ :status => 200, :body => %{ :id => 1234, :name => "CAP-1234" }}}
    end

    def add_comment_to_issue(comment, id, headers \\ []) do    
        { :ok, %{ :status => 200, :body => %{ :id => 1234, :name => "CAP-1234" }}}
    end
    
    defp parse_body(body) do           
        case Jason.decode(body) do
          { :ok, decoded } -> { :ok, decoded }
          { :error, error } -> { :error, error }
        end        
    end
    
    defp handle_response({ :error, error }) do        
        %{ status: 500, payload: error}
    end

    defp handle_response({ :ok, %{ "total" => 0 }}) do
        %{ status: 404, payload: nil}
    end

    defp handle_response({ :ok, body }) do        
        %{ status: 200, payload: body["issues"] }
    end
end
