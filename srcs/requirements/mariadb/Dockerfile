FROM debian:buster

# We need to pass the following arguments to the build command
ARG DB_DATABASE
ARG DB_USER_NAME
ARG DB_USER_PASSWORD
ARG DB_ROOT_PASSWORD

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
# MariaDB Server:
# 	1.	The MariaDB Server is the core component of the database management system.
#		It is responsible for managing and storing the actual database data,
#		handling queries, and providing access to the data.
# 	2.	The server listens for incoming database connections from clients and processes
#		SQL queries and commands sent by those clients.
# 	3.	It is the central component that stores and manages databases, tables, and data.
RUN apt-get install -y mariadb-server
# Debian-based Linux distributions (including Ubuntu) to remove cached package files
# that were previously downloaded by the APT (Advanced Package Tool) package manager
# during the package installation or upgrade process. 
RUN apt-get clean -y

# You notice we call mysql and not mariadb. This is because MariaDB
# is a fork of MySQL, even though they are different the name of the
# commands we invoke and folders we use are as if we were using MySQL
# itself. This is because MariaDB is a drop-in replacement for MySQL.

# We create a directory for the MariaDB Server socket file and change its ownership to the mysql user
RUN mkdir -p /var/run/mysqld
# We change the ownership of the /var/run/mysqld directory to the mysql user
RUN chown -R mysql:mysql /var/run/mysqld

RUN service mysql start \
	&& mysql -u root -e \
	"CREATE DATABASE IF NOT EXISTS $DB_DATABASE; \
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD'; \
	GRANT ALL PRIVILEGES ON $DB_DATABASE.* TO '$DB_USER_NAME'@'%' IDENTIFIED BY '$DB_USER_PASSWORD'; \
	GRANT ALL PRIVILEGES ON $DB_DATABASE.* TO '$DB_USER_NAME'@'localhost' IDENTIFIED BY '$DB_USER_PASSWORD'; \
	FLUSH PRIVILEGES;"

# Copy our configuration files to the correct location in the container
# The mariadb.conf.d directory contains configuration files for MariaDB Server.
COPY ./conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf
# We expose the port 3306 to allow connections to our database from the outside
EXPOSE 3306

# ENTRYPOINT is a Docker instruction that specifies the default command to be executed when a container is started.
# The -- that follows dumb-init is used to separate the entry point command
# from the command that follows it. Any command passed to the container will be treated as arguments to dumb-init
ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD ["mysqld", "--bind-address=0.0.0.0" ]
# CMD is another Docker instruction that specifies the default command to be executed
# when a container is started, but it can be overridden by providing a command when starting the container.

# 1.	mysqld is the MariaDB server process. This command starts the MariaDB server.
# 2.	--bind-address=0.0.0.0 is an argument passed to mysqld. It tells the MariaDB
#		server to bind and listen on all available network interfaces, making the database
#		accessible from outside the container.

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
