FROM azukiapp/ruby
MAINTAINER Turniquette <info@turniquette.com>

RUN adduser --disabled-password --gecos "" deploy
USER deploy
