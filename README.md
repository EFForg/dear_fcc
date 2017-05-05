# Dear FCC

## Setup / Deployment

There are example files docker-compose.yml.example and .env.example illustrating a production deployment with docker.

    $ cp docker-compose.yml.example docker-compose.yml
    $ cp .env.example .env  
    $ docker-compose up --build

## Configuration

There are two files for configuration of the letter campaign:

### `config/proceeding.yml`
Describes the FCC proceeding to which comments will be submitted.

### `config/comments-elements.yml`
Describes the letter template which is presented to the user. There are 3 types of elements in the letter:

   * `type: user-select`  
      give the user a choice of what language to use
   * `type: user-select-or-other`  
      same as `user-select` but also provides an "Other..." option which allows free-form entry
   * `type: random`  
      randomly selects one of the choices
