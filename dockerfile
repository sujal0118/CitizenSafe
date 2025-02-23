# Use official Tomcat image
FROM tomcat:10.1.24-jdk17

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat

# Copy WAR file to Tomcat's webapps directory
COPY target/FraudDetectionSystem-0.0.1-SNAPSHOT.war $CATALINA_HOME/webapps/FraudDetectionSystem.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]

