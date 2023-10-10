FROM debian:buster

# Update and upgrade the system
RUN apt-get update -y
RUN apt-get upgrade -y

# Install the required packages
# In summary, dumb-init is a small utility that helps with process management
# and signal handling within containers. It is often used as an entry point in
# container images to ensure that the processes running inside containers behave
# as expected and that signals are correctly handled, making containerized
# applications more robust and predictable.
RUN apt-get install -y dumb-init
# NGINX:
# 	1.	NGINX is a free, open-source, high-performance HTTP server and reverse proxy,
#		as well as an IMAP/POP3 proxy server. NGINX is known for its high performance,
#		stability, rich feature set, simple configuration, and low resource consumption.
# 	2.	NGINX is one of a handful of servers written to address the C10K problem.
#		Unlike traditional servers, NGINX doesn’t rely on threads to handle requests.
#		Instead it uses a much more scalable event-driven (asynchronous) architecture.
#		This architecture uses small, but more importantly, predictable amounts of memory
#		under load.
# OPENSSL:
# 	1.	OpenSSL is a robust, commercial-grade, and full-featured toolkit for the Transport
#		Layer Security (TLS) and Secure Sockets Layer (SSL) protocols. It is also a general-purpose
#		cryptography library.
RUN apt-get install -y openssl nginx
# Debian-based Linux distributions (including Ubuntu) to remove cached package files
# that were previously downloaded by the APT (Advanced Package Tool) package manager
# during the package installation or upgrade process. 
RUN apt-get clean -y


# Generate SSL certificate
# -x509: This option outputs a self-signed certificate instead of a certificate request.
# -days: When the -x509 option is being used this specifies the number of days to certify.
# -nodes: If this option is specified then if a private key is created it will not be encrypted.
# -newkey: This option creates a new certificate request and a new private key.
# -rsa:4096: This option creates a new certificate request and a new private key of size 4096 bits.
# -keyout: This gives the filename to write the newly created private key to.
# -out: This specifies the output filename to write to or standard output by default.
# -sha256: This specifies the message digest to sign the request with.
# -subj: This option sets the subject name to use. It can be overridden by the -subj command line argument.
# -subj: "/C=ES/ST=MADRID/L=MADRID/O=wordpress/CN=fsalazar.42.fr"
# -C: Country Name (2 letter code)
# -ST: State or Province Name (full name)
# -L: Locality Name (eg, city)
# -O: Organization Name (eg, company)
# -CN: Common Name (e.g. server FQDN or YOUR name)
RUN openssl req -x509 -days 365 -nodes -newkey rsa:4096 \
    -keyout /etc/ssl/fsalazar.42.fr.key \
    -out /etc/ssl/fsalazar.42.fr.crt \
    -sha256 -subj "/C=ES/ST=MADRID/L=MADRID/O=42Madrid/CN=fsalazar.42.fr"

# Copy NGINX config files
COPY ./conf/nginx.conf /etc/nginx/sites-available/fsalazar.42.fr.conf

# Create a symbolic link to the NGINX config file
# ln -s is used to create a symbolic link to a file or directory.
# The -s option creates a symbolic link, if not specified a hard link is created.
# A symbolic link is a link to another file or directory using its path.
# We use is here to create a symbolic link to the NGINX config file. Thus we can
# modify the NGINX config file without having to rebuild the image.
RUN ln -s /etc/nginx/sites-available/fsalazar.42.fr.conf /etc/nginx/sites-enabled/fsalazar.42.fr.conf

# As we did in MariaDB we expose the port 443 to the host machine
# allowing the host machine to access the container through this port.
EXPOSE 443

# ENTRYPOINT is a Docker instruction that specifies the default command to be executed when a container is started.
# The -- that follows dumb-init is used to separate the entry point command
# from the command that follows it. Any command passed to the container will be treated as arguments to dumb-init
ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

# CMD is another Docker instruction that specifies the default command to be executed
# when a container is started, but it can be overridden by providing a command when starting the container.

# 1.    nginx is the NGINX server process. This command starts the NGINX server.
# 2.    -g daemon off; is an argument passed to nginx. It tells the NGINX
#		server to run in the foreground.
#       By default, NGINX runs in the foreground, but the -g daemon off;
#       option tells NGINX to stay in the foreground so that Docker can track
#       the process properly (otherwise, Docker will start the container and
#       then immediately exit, thinking that NGINX has stopped running).
#3.     We use CMD instead of ENTRYPOINT because we want to be able to override
#       the command when starting the container. If we used ENTRYPOINT, the
#       command passed to the container would be treated as arguments to
#       dumb-init, not to NGINX.
CMD [ "nginx", "-g", "daemon off;" ]

# Pros and Cons of Alpine Linux:
# Pros:
# 1. Lightweight: Alpine is minimalistic and lightweight, ideal for resource-constrained environments.
# 2. Security: Strong focus on security with grsec/PaX kernel patches and musl libc.
# 3. Package Manager (APK): Fast and efficient package management.
# 4. Docker-Friendly: Popular for Docker containers due to small image size.
# 5. Rolling Release: Continuous updates without major version upgrades.
# 6. Documentation: Well-maintained documentation.

# Cons:
# 1. Limited Software Repositories: May have fewer software packages than Debian.
# 2. Learning Curve: Unique package management and configuration may require adjustment.

# Pros and Cons of Debian Buster:
# Pros:
# 1. Stability: Known for stability, suitable for production environments.
# 2. Wide Software Repositories: Vast repository of software packages.
# 3. Long-Term Support (LTS): LTS releases with extended support.
# 4. Well-Established: Large community, extensive documentation, and a proven track record.
# 5. Multiple Architectures: Supports a wide range of hardware.

# Cons:
# 1. Resource Intensive: More resource usage compared to Alpine.
# 2. Slower Updates: Older package versions, not ideal for bleeding-edge software.
# 3. Complex Configuration: Extensive configuration options.
# 4. Large Installation Size: Default installation can be large, may be an issue for limited storage.
