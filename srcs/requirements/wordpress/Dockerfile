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

# Install curl and less. These are not strictly required, but they are useful
# for troubleshooting and debugging
# Curl is a command-line tool for transferring data specified with URL syntax.
# Less is a terminal pager program on Unix, Windows, and Unix-like systems used to view (but not change) the contents of a text file one screen at a time.
RUN apt-get install -y curl less

# Install mariadb-client. This is required for the wordpress CLI to be able to
# connect to the database
# Install php-fpm and php-mysql. These are required for wordpress to run
# the php code and connect to the database.
RUN apt-get install -y \
	php-fpm php-mysql php-mysqli \
	mariadb-client

# Debian-based Linux distributions (including Ubuntu) to remove cached package files
# that were previously downloaded by the APT (Advanced Package Tool) package manager
# during the package installation or upgrade process.
RUN apt-get clean -y

# Install the wordpress CLI. This isn't a package that we can install via apt,
# so we need to download it off github and set it to executable
# The -o option is used to write output to a file instead of stdout.
# The -x option is used to set the executable bit.
# WordPress CLI is a command line interface for WordPress. You can update plugins, configure multisite installs and much more, without using a web browser.
# We need to install the WordPress CLI to be able to install WordPress from the command line.
RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
	&& chmod +x /usr/local/bin/wp

# Make a directory for the wordpress files
RUN mkdir -p /var/www/html/wordpress

# Copy our script into the container. This script will be run when the container
# starts up. It will install wordpress and start php-fpm.
COPY ./tools/setup.sh /tmp/

# Copy the php-fpm configuration file into the container. This file will be used
# to configure php-fpm when the container starts up.
COPY ./tools/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Expose port 9000. This is the port that php-fpm will listen on.
EXPOSE 9000

# Set the entrypoint and command for the container. The entrypoint is set to
# dumb-init, which will be used to run the command. The command is set to
# /bin/bash /tmp/setup.sh, which will be run when the container starts up.
# The command will install wordpress and start php-fpm.
ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]
CMD ["/bin/bash", "/tmp/setup.sh" ]

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
