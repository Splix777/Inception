FROM    debian:buster

RUN apt update -y
RUN apt upgrade -y
RUN apt install nginx -y

RUN apt install vim -y
RUN apt install curl -y

RUN mkdir -p /etc/nginx/ssl
RUN apt install openssl -y


RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=42 School/OU=fsalazar/CN=fsalazar"

RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]










# EXPOSE 443



# FROM  - defines a base for your image. exemple : FROM debian:buster

# RUN - executes any commands in a new layer on top of the current
#       image and commits the result. RUN also has a shell form for running commands.

# WORKDIR - sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, and ADD
#           instructions that follow it in the Dockerfile. (You go directly in the directory you choose)

# COPY - copies new files or directories from and adds them to the filesystem of the container at the path.

# CMD - lets you define the default program that is run once you start the container based on this image.
#       Each Dockerfile only has one CMD, and only the last CMD instance is respected when multiple ones exist.

#   The req command is used to generate a certificate signing request (CSR) or a self-signed certificate.
#   The -x509 option tells OpenSSL to generate a self-signed certificate instead of a CSR.

#   The -nodes option tells OpenSSL not to encrypt the private key with a passphrase. This means that the
#   private key will not be protected by a password, and it will be stored in plaintext.
#   This is generally not recommended for production environments, as it can make the key more vulnerable
#   to unauthorized access.

#   The -days option specifies the number of days that the certificate should be valid for. In this case,
#   the certificate will be valid for 365 days (one year).

#   The -newkey option specifies that a new private key should be generated. The rsa:2048 argument tells
#   OpenSSL to generate an RSA key with a length of 2048 bits.

#   The -keyout option specifies the file where the private key should be stored, and the -out option
#   specifies the file where the certificate should be stored.

#   The -subj option specifies the subject of the certificate. The subject includes information about the
#   organization that the certificate will be used for, as well as information about the server where the
#   certificate will be installed. In this case, the subject includes the country (C=ES), the location (L=Madrid),
#   the organization (O=" "), the organizational unit (OU=" "), and the common name (CN=" ").

#   After running this command, a self-signed SSL/TLS certificate and private key will be generated and stored
#   in the specified files. You can then use these files to configure an NGINX server to use SSL/TLS encryption.
#   Keep in mind that self-signed certificates are not trusted by most web browsers, so you will typically need
#   to obtain a certificate from a trusted certificate authority (CA) for use in a production environment.