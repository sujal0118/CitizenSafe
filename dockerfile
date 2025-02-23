# Use official Tomcat image
FROM tomcat:10.1.24-jdk17

# Set working directory to Tomcat home
WORKDIR /usr/local/tomcat

# Copy WAR file to Tomcat's webapps directory
COPY target/FraudDetectionSystem-0.0.1-SNAPSHOT.war webapps/FraudDetectionSystem.war

# Expose port 8080 for Tomcat
EXPOSE 8080

# Ensure execute permission for catalina.sh
RUN chmod +x /usr/local/tomcat/bin/catalina.sh

# Start Tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
