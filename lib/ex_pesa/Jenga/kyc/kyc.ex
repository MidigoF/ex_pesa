defmodule ExPesa.Jenga.KYC do
  @moduledoc """
  KYC enabales quering the various registrar of persons in the various countries in East Africa. 
  Visit https://developer.jengaapi.io/reference#identity-verification to see more details
  """
  import ExPesa.Jenga.JengaBase
  alias ExPesa.Jenga.Signature

  @spec request(map()) :: {:error, any()} | {:ok, any()}
  def request(
        %{
          identity: %{
            documentType: _documentType,
            firstName: _firstName,
            lastName: _lastName,
            dateOfBirth: _dateOfBirth,
            documentNumber: documentNumber,
            countryCode: countryCode
          }
        } = requestBody
      ) do
    message = "#{merchant_code()}#{documentNumber}#{countryCode}"

    make_request("/customer-test/v2/identity/verify", requestBody, [
      {"signature", Signature.sign(message)}
    ])
  end

  def request(_), do: {:error, "Required Parameters missing, check your request body"}

  defp merchant_code do
    Application.get_env(:ex_pesa, :jenga)[:username]
  end
end
