# Launch

TODO: add project overview here

## Getting started

It's advised to use the [asdf version manager](https://asdf-vm.com/) and the following plugins:

- [Elixir](https://github.com/asdf-vm/asdf-elixir)
- [Erlang](https://github.com/asdf-vm/asdf-erlang)
- [Postgresql](https://github.com/asdf-vm/asdf-erlang)

Once all of these are installed, invoke `asdf install` at the root of the project to install the required tools.

Usage of asdf is not mandatory, but then you have to manage your own tool versions. Consult the .tool-versions files for the required tools. It is also possible to use asdf for some tools (e.g. Elixir and Erlang), while using the system-wide installation for others (e.g. PostgreSQL). In this case, don't install the corresponding asdf plugin.

In the PostgreSQL instance the password for the `postgres` user should be set to `postgres`.

## First test

1. Fetch the deps with `mix deps.get`
2. Recreate the test database with `MIX_ENV=test mix ecto.reset`
3. Verify that all the tests are passing with `mix test`

## Running locally

1. Create the dev database with `mix ecto.reset`
2. Invoke `iex -S mix phx.server`

The system will start and listen on the port 4000.

## Running inside a docker container

Various make targets are present which can start the dockerized backend environment (so called devstack):

- `make devstack` - builds the images and starts the required devstack containers.
- `make devstack-shell` - connects to the main devstack container. Inside this container you can invoke regular commands, such as `mix test`.
- `make devstack-clean` - stops all the containers for this project.

The main container will also map the port 4000 to the host. Consequently, you can't start the local development server while the devstack containers are running (or vice versa). Other tasks can run safely, so for example you can run local tests while the devstack containers are running.

## Running the production version locally

In some cases you may want run the production version locally. This can be useful for some testing inside the environment which is more similar to production. For example, a dev version might use a mock mail adapter to send e-mails, while in the OTP release the real mail adapter is used. The suggested way to do this is to build and run the OTP release locally:

1. run `mix release` to build the OTP release
2. run `MIX_ENV=dev mix operator_template > /tmp/launch.env`
3. open /tmp/launch.env and uncomment all the default settings, tweaking the ones which you need (e.g. access tokens for external services)
4. invoke `(. /tmp/launch.env && _build/prod/rel/launch/bin/launch start)`
