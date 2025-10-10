FROM ruby:3.2-alpine

WORKDIR /app

RUN apk add --no-cache postgresql-dev build-base

COPY Gemfile ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "3000"]
