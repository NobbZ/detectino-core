ExUnit.configure(exclude: [skip: true])
ExUnit.start

Mix.Task.run "ecto.create", ~w(-r DtWeb.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r DtWeb.Repo --quiet)

