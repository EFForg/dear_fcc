# Dear FCC

## Setup / Deployment

There are example files [docker-compose.yml.example](https://gitlab.eff.org/ed/dear_fcc/blob/master/docker-compose.yml.example)
and [.env.example](https://gitlab.eff.org/ed/dear_fcc/blob/master/.env.example)
illustrating a production deployment with docker.

    $ cp docker-compose.yml.example docker-compose.yml
    $ cp .env.example .env  
    $ docker-compose up --build

## Configuration

There are two files for configuration of the letter campaign:

### [`config/proceeding.yml`](https://gitlab.eff.org/ed/dear_fcc/blob/master/config/proceeding.yml)
Describes the FCC proceeding to which comments will be submitted.

### [`config/comments-elements.yml`](https://gitlab.eff.org/ed/dear_fcc/blob/master/config/comment-elements.yml)
Describes the comment template which is presented to the user. There are 3 types of elements in the comment:

   * `type: user-select`  
      give the user a choice of what language to use
   * `type: user-select-or-other`  
      same as `user-select` but also provides an "Other..." option which allows free-form entry
   * `type: random`  
      randomly selects one of the choices

## CSV Export

The ECFS API rate limits submissions to about 500/hour. For 17-108 "Restoring Internet Freedom" they have set up [a form](https://www.fcc.gov/restoring-internet-freedom-comments-wc-docket-no-17-108) for bulk submissions, which may need to be used if the rate limit becomes a problem.

They also ask that organizations use this bulk upload form in any case, if they expect to submit a lot of comments.

To export the job queue to CSV in order to upload, run this command.

    $ rake dear_fcc:create_csv >comments.csv

Make sure to save the output because **the jobs will be deleted from the queue**. The CSV output will be at most 5 megabytes since that is the maximum file size accepted by the FCC. If there are still jobs in the queue, generate additional CSV files by running the command again.
