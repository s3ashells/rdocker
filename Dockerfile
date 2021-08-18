FROM ubuntu:20.04

RUN apt update && apt install -y locales && rm -rf /var/lib/apt/lists/* \ && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.UTF-8
# installing the dependencies
RUN apt update -qq
RUN apt install --no-install-recommends software-properties-common dirmngr 
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# Adding CRAN repository to system sources list
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
# Installing R-base
RUN apt install r-base=3.6.3

WORKDIR /code

COPY Rprofile.site /usr/lib/R/etc/

COPY ./shinyproxy /code

# Install R-base packages
RUN R -e "install.packages(c('shiny', 'rmarkdown'))"

RUN R -e "shinyproxy::run_01_hello()"