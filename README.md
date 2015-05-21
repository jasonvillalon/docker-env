# Docker::Env

This is a small utility for Ruby on Rails developers using Docker in their development environment.
It creates environment variables similar to those created by docker inside a container linked to other containers.
It's purpose is to allow you to run your dockerized Rails application outside of a docker container,
while still allowing to connect to other services that are running inside docker containers.

## Usage example

Consider following fig/docker-compose yaml:

    mongodb:
        image: dockerfile/mongodb
        command: mongod --smallfiles
        ports:
            - "27017"
            - "28017"

    app:
        build: .
        command: rails s
        volumes:
            - .:/app
        ports:
            - "3000:3000"
        links:
            - mongodb

Environment variables created by docker inside the 'app' container will be similar to this:

    MONGODB_1_NAME=/cnpback_app_run_41/mongodb_1
    MONGODB_1_PORT=tcp://172.17.0.85:27017
    MONGODB_1_PORT_27017_TCP=tcp://172.17.0.85:27017
    MONGODB_1_PORT_27017_TCP_ADDR=172.17.0.85
    MONGODB_1_PORT_27017_TCP_PORT=27017
    MONGODB_1_PORT_27017_TCP_PROTO=tcp
    MONGODB_1_PORT_28017_TCP=tcp://172.17.0.85:28017
    MONGODB_1_PORT_28017_TCP_ADDR=172.17.0.85
    MONGODB_1_PORT_28017_TCP_PORT=28017
    MONGODB_1_PORT_28017_TCP_PROTO=tcp
    MONGODB_NAME=/cnpback_app_run_41/mongodb
    MONGODB_PORT=tcp://172.17.0.85:27017
    MONGODB_PORT_27017_TCP=tcp://172.17.0.85:27017
    MONGODB_PORT_27017_TCP_ADDR=172.17.0.85
    MONGODB_PORT_27017_TCP_PORT=27017
    MONGODB_PORT_27017_TCP_PROTO=tcp
    MONGODB_PORT_28017_TCP=tcp://172.17.0.85:28017
    MONGODB_PORT_28017_TCP_ADDR=172.17.0.85
    MONGODB_PORT_28017_TCP_PORT=28017
    MONGODB_PORT_28017_TCP_PROTO=tcp

Now, let's suppose your mongoid.yml file has this entry:

    development:
        sessions:
            default:
            database: your_app_development
            hosts:
                - <%= "#{ENV['MONGODB_1_PORT_27017_TCP_ADDR']}:#{ENV['MONGODB_1_PORT_27017_TCP_PORT']}" %>

And you want to run your application outside of the docker container
(for example to connect with a debugger from your IDE)
without changing your configuration files
and without setting any environment variables manually.

When installed in your Gemfile, docker-env will create a subset of these variables for you:

    MONGODB_1_PORT_27017_TCP_ADDR=172.17.0.85
    MONGODB_1_PORT_27017_TCP_PORT=27017
    MONGODB_1_PORT_28017_TCP_ADDR=172.17.0.85
    MONGODB_1_PORT_28017_TCP_PORT=28017
    MONGODB_PORT_27017_TCP_ADDR=172.17.0.85
    MONGODB_PORT_27017_TCP_PORT=27017
    MONGODB_PORT_28017_TCP_ADDR=172.17.0.85
    MONGODB_PORT_28017_TCP_PORT=28017

## Installation

Add this line to your application's Gemfile:

    gem 'docker-env', group: :development, github: 'cthulhu666/docker-env'

And then execute:

    $ bundle

## Contributing

1. Fork it ( https://github.com/[my-github-username]/docker-env/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
