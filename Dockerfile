FROM ruby:alpine

RUN apk add --update build-base \
                     libxml2-dev \
                     libxslt-dev \
  && rm -rf /var/cache/apk/*

WORKDIR /usr/app

COPY Gemfile .
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install

COPY . .

CMD ["ruby", "/usr/app/main.rb"]
