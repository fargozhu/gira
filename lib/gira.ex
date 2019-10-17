defmodule Gira do
  @moduledoc """
  This module defines the Gira contract/interface
  """
  @enforce_keys [:base_url, :authorization_token]
  defstruct(
    base_url: nil,
    authorization_token: nil
  )

  @type t() :: %__MODULE__{
          base_url: String.t(),
          authorization_token: String.t()
        }

  def new(base_url, auth_token) do
    %Gira{
      base_url: base_url,
      authorization_token: auth_token
    }
  end

  def get_issue_basic_info_by_query(client, filter) do
    {:ok, response} =
      Gira.GiraWrapper.get(
        get_base_url(client) <> "/search" <> "?jql=" <> filter <> "&fields=total",
        [{"Authorization", get_authorization_token(client)}, {"Content-type", "application/json"}]
      )
  end

  def create_issue_with_basic_info(client, payload) do
    {:ok, response} =
      Gira.GiraWrapper.post(
        get_base_url(client) <> "/issue",
        payload,
        [{"Authorization", get_authorization_token(client)}, {"Content-type", "application/json"}]
      )
  end

  defp get_base_url(client), do: client.base_url
  defp get_authorization_token(client), do: client.authorization_token
end
