# Use an official Tomcat image as the base
FROM tomcat:10.1.24-jdk17

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat

# Copy WAR file to Tomcat webapps directory
COPY target/FraudDetectionSystem.war $CATALINA_HOME/webapps/FraudDetectionSystem.war

# Expose port 8080 for the application
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
