# Nginx base image required to generate mirrors
FROM nginx:latest
# Author Name <Mailbox >
MAINTAINER Fa <fa@163.com>
# Delete the default nginx configuration, which can also not be deleted her, but must create a. if configuration file and must be in the **/conf.d/folder
RUN rm /etc/nginx/conf.d/default.conf
# Add **.conf configuration file to the default profile path of nginx, conf. /default.conf for files and paths to be created, the first holder in the above map
ADD conf.d/default.conf /etc/nginx/conf.d/
# The directory of access to copy items to the nginx configuration configuration, Dist/is the package of items shown in the graph above, /usr/share/nginx/snnu_ui/the directory of access to the configuration file
COPY dist//usr/share/nginx/snnu_ui/
