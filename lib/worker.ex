defmodule StatexClient.Worker do
	use Silverb, 	[
						{"@ttl", (res = :application.get_env(:statex_client, :ttl, nil); true = (is_integer(res) and (res > 0)); res)},
						{"@callback_module", (res = :application.get_env(:statex_client, :callback_module, nil); true = (is_atom(res) and (res != nil)) ; res)},
						{"@app", (res = :application.get_env(:statex_client, :app, nil); true = ((is_binary(res) or is_atom(res)) and (res != nil)) ; res)},
						{"@host", (res = :application.get_env(:statex_client, :host, nil); true = is_binary(res) ; res)}
					]
	use ExActor.GenServer, export: __MODULE__
	use StatexClient.HTTP
	definit do
		{:ok, nil, @ttl}
	end
	definfo :timeout do
		case %{cmd: "set_state", args: @callback_module.statex_callback() |> HashUtils.set(:host, @host) |> HashUtils.set(:app, @app) |> Map.delete(:__struct__)} |> http_post() do
			%{ok: true} -> :ok
			error -> StatexClient.error("got error on requesting server #{inspect error}")
		end
		{:noreply, nil, @ttl}
	end
end