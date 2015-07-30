defmodule StatexClient.HTTP do
  use Silverb,  [ 
                  {"@statex_server", (res = :application.get_env(:statex_client, :statex_server, nil); true = is_binary(res) ; res)},
                  {"@hackney_opts", (res = :application.get_env(:statex_client, :hackney_opts, nil); true = is_list(res) ; res)} 
                ]
  defmacro __using__(_) do
    quote location: :keep do
      use Httphex,  [
                      host: unquote(@statex_server), 
                      opts: unquote(@hackney_opts),
                      encode: &StatexClient.encode/1,
                      decode: &StatexClient.decode/1,
                      gzip: false,
                      client: :httpoison
                    ]
    end
  end
end
defmodule StatexClient do
  use Application
  use Silverb, [{"@memo_ttl", (res = :application.get_env(:statex_client, :memo_ttl, nil); true = (is_integer(res) and (res > 0)); res)}]
  use StatexClient.HTTP
  use Hashex, [__MODULE__.Info]
  use Logex, [ttl: 100]

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(StatexClient.Worker, [arg1, arg2, arg3])
      worker(StatexClient.Worker, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StatexClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
  def stop(_), do: :erlang.halt

  def encode(some), do: Tinca.memo(&Jazz.encode!/1, [some], @memo_ttl)
  def decode(some), do: Tinca.memo(&Jazz.decode!/2, [some, [keys: :atoms]], @memo_ttl)

  defmodule Info do
    defstruct   app: nil,
                host: nil,
                ok: false,
                info: "",
                data: nil
  end

  def statex_callback, do: %StatexClient.Info{ok: true}
  def send(mess = %StatexClient.Info{}), do: StatexClient.Worker.send_process(mess)

end
