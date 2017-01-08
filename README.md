Page Crawler
============
Simple project to read and extract page content 

# Dependencies

* Ruby 2.3.1 
* Postgresql and Nokogiri dependencies
* Redis

# For Development Mode

In a terminal:
```
# Copy the .env.example file to .env
cp .env.example .env

# Open the .env file and configure it, if necessary 

# Execute 
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec sidekiq
```

Open another terminal and execute `rails server`

# For Production mode

Create a new database.
For each terminal, export all environment variables:

```
export PAGE_CRAWLER_DB_PORT=<postgres port>
export PAGE_CRAWLER_DB_USER=<postgres user>
export PAGE_CRAWLER_DB_PASSWORD=<postgres user password>
export PAGE_CRAWLER_DB_NAME=<postgres database>
export SECRET_KEY_BASE=<postgres database>
export REDIS_URL=<redis url like: redis://localhost:6379/0>
export RAILS_ENV=production
```

Execute in a terminal `bundle exec rake db:migrate` and `rails server`, open another one, export all variables and
execute `bundle exec sidekiq`. 


## Production in Docker

You must have docker and docker-compose, then execute in a terminal `docker-compose up -d`
In the end, you will be able to access at `http://localhost:3000/v1/pages`

# API Endpoint
Here are the endpoint descriptions

| Verb | Endpoint | Description |
| --- | --- | --- |
| GET | /v1/pages | List all previous urls and content stored |
| POST | /v1/pages/enqueue | Enqueue a new url to be processed and get its page content |